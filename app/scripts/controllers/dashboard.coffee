### THIS IS THE PLANNER. It can be quite confusing because it used to be the dashboard.
I tried to rename it from dashboard to planner, but it did not work directly. I did not want
to waste more time on that as this as it is will not be used in the future.

Kim
###

'use strict'

angular.module('switchfitApp.dashboard', ['ui.router'])
  .config ($stateProvider) ->
    $stateProvider
      .state 'dashboard',
        url: '/planner',
        templateUrl: 'views/dashboard.html'
        controller: 'DashboardCtrl as dashboard'
      .state 'demo',
        url: '/demo',
        templateUrl: 'views/demo/main.html'
        controller: 'DashboardCtrl as dashboard'

class Dashboard
  constructor: (@$scope, @$log, User, @Course, @Day, @Notifications, @$rootScope, @$translate, @$modal, @usSpinnerService) ->
    @dragStart = false
    @dragIndex = null
    @activeDraggable = false
    @draggableDragging = {}
    @droppingOverOut = {}
    @draggingWorkout = false

    @$scope.isLoading = false

    @typesCommon = [{
        type: 'meal',
        itemType: {
          slug: 'meal_a',
          abbr: 'A'
        }
      },
      {
        type: 'meal',
        itemType: {
          slug: 'meal_b',
          abbr: 'B'
        }
      },
      {
        type: 'meal',
        itemType: {
          slug: 'meal_c',
          abbr: 'C'
        }
      },
      {
        type: 'meal',
        itemType: {
          slug: 'meal_c',
          abbr: 'C'
        }
      }
    ]
    @typeDetox = {
    'type': 'meal',
    'itemType': 'detox'
    }

    @currentDate = (new Date()).getDate()
    @currentMoment = moment()
    @$rootScope.currentUser.$promise.then =>
      @user = @$rootScope.currentUser
      @$scope.userVegetarian = @user.activeUserCourse.isVegetarian
      user = @user
      @$scope.updateVegetarian = () =>
        if @$scope.userVegetarian
          data = {is_vegetarian : true }
        else
          data = {}
        User.Vegetarian.post { userId: user.id, courseId: user.activeUserCourse.id}, data, (response) =>
          user.activeUserCourse.isVegetarian = response.isVegetarian
          @getUserDays(true)
      @getUserDays()

    @bindModalSelects()

    # one popover and hide if click out of popover
    angular.element('body').on 'click', (e) =>
      angular.element('[data-toggle="popover"]').each(() ->
        if (!(angular.element(this).is(e.target) || angular.element(this).has(e.target).length > 0) and angular.element(this).siblings('.popover').length != 0 and angular.element(this).siblings('.popover').has(e.target).length == 0)
          angular.element(this).siblings('.popover').remove()
          angular.element(this).scope().tt_isOpen = false;
      )

    window.Intercom('trackEvent', 'page-visit-planner')

  getUserDays: (reload=false)=>
    @$scope.isDaysLoading = true
    @weekDays = []
    @userDays = []
    firstDay = moment().startOf('isoWeek')
    date = new Date()
    momentDate = moment(date)
    endCourseDate = moment(@$rootScope.userCourse.course.dateTo).add(1, 'days')

    @$scope.courseFinished = endCourseDate.diff(momentDate) < 0 ? true : false
    #    wDays = [ 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday' ]
    # week days trans ids
    wDays = [
      'frontend.days.monday',
      'frontend.days.tuesday',
      'frontend.days.wednesday',
      'frontend.days.thursday',
      'frontend.days.friday',
      'frontend.days.saturday',
      'frontend.days.sunday'
    ]
    # days
    if reload
      @$rootScope.days = @Day.query { userId: @user.id, courseId: @$rootScope.userCourse.id }
    @$rootScope.days.$promise.then (days) =>
      for i in [1..7]
        userDay = days.filter (day) =>
          courseDayDate = moment(day.courseDayDate)
#          console.log('userDay: ' + courseDayDate.format('YYYY-MM-DDTHH:mm:ssZ') + ' compareDay: ' + firstDay.format('YYYY-MM-DDTHH:mm:ssZ') + ' result: ' + (courseDayDate.year() == firstDay.year() && courseDayDate.month() == firstDay.month() && courseDayDate.date() == firstDay.date()))
          return (courseDayDate.year() == firstDay.year() &&
          courseDayDate.month() == firstDay.month() &&
          courseDayDate.date() == firstDay.date())
        if userDay.length != 0 and userDay[0].timetableItems.length != 0
          userDay = userDay[0]
        else
          emptyDay = angular.copy(firstDay)
          if i < 7
            userDay = {
              courseDayDate: emptyDay.format('YYYY-MM-DDTHH:mm:ssZ'),
              timetableItems: angular.copy(@typesCommon)
            }
          else
            userDay = { courseDayDate: emptyDay.format('YYYY-MM-DDTHH:mm:ssZ') }
        userDay.canEdit = moment(userDay.courseDayDate).isBefore(momentDate)
        if @$scope.courseFinished
          userDay.canEdit = false
        userDay.day = firstDay.date()
        @userDays.push userDay
        @weekDays.push { day: wDays[i - 1], date: firstDay.startOf('day').date() }
        firstDay.add('days', 1)

      # days load
      @usSpinnerService.stop('dashboard-loader')
      @$scope.isDaysLoading = false

      @$translate('frontend.notices.day_data').then (translation) =>
        @noticesDayDataTranslation = translation
        @processNotices()
      # current weight by last week measurement
      lastWeekDays = days.filter (day) =>
        courseDayDate = moment(day.courseDayDate)
        return (parseInt(courseDayDate.format('W')) == parseInt((momentDate.format('W') - 1))) && null != day.weight
      if lastWeekDays.length > 0
        lastWeekLastDay = lastWeekDays.pop()
        @$rootScope.currentWeight = lastWeekLastDay.weight

  saveDay: (day, updateDayTimetable=false) =>
    if day.cigarettes > 50 then day.cigarettes = 50
    @Day.add { userId: @user.id, courseId: @$rootScope.userCourse.id }, {
      mood: day.mood,
      bloodGlucoseLevel: day.bloodGlucoseLevel
      cravingsLevel: day.cravingsLevel
      hungerLevel: day.hungerLevel
      numberOfHits: day.numberOfHits
      waterIntake: day.waterIntake
      weight: day.weight
      cigarettes: day.cigarettes
      courseDayDate: moment(day.courseDayDate).format('DD.MM.YYYY')
      timetableItems: day.timetableItems
    }, (data) =>
      @clearNotices(data)
      if updateDayTimetable
        # update day
        savedCourseDayDate = moment(day.courseDayDate)
        for d,i in @userDays
          courseDayDate = moment(d.courseDayDate)
          if courseDayDate.year() == savedCourseDayDate.year() &&
            courseDayDate.month() == savedCourseDayDate.month() &&
            courseDayDate.date() == savedCourseDayDate.date()
              @userDays[i].timetableItems = data.timetableItems

  processNotices: =>
    if @Notifications.notices.length > 0
      @processDayNotices()
    else
      notices = @Notifications.get { userId: @user.id, status: 'new' }
      notices.$promise.then (notices) =>
        @Notifications.notices = notices
        @processDayNotices()

  processDayNotices: =>
    weekDayNotices = {}
    currentDay = moment()
    for weekDay in @weekDays
      weekDayNotices[weekDay.date] = []
    for notice in @Notifications.notices
      if @isDayNotice(notice.type)
        if notice.extData.day?
          dateDay = moment(notice.extData.day).format('D')
          if weekDayNotices[dateDay]?
            weekDayNotices[dateDay].push(notice)
    for userDay in @userDays
      if @isDayMeasurementsFill(userDay)
        day = moment(userDay.courseDayDate)
        dateDaySimple = day.format('D')
        if weekDayNotices[dateDaySimple]? and currentDay.diff(day) > 0
          weekDayDataNotice = weekDayNotices[dateDaySimple].filter (dayNotice) =>
            return dayNotice.type == 'day_data'
          if weekDayDataNotice.length == 0
            weekDayNotices[dateDaySimple].push {type: 'day_data_front', text: @noticesDayDataTranslation, status: 'new'}

    @Notifications.dayNotices = weekDayNotices

    @$scope.dayNotices = (day) =>
      if @Notifications.dayNotices[day]?
        return @Notifications.dayNotices[day]
      else
        return []

  clearNotices: (dayObj) =>
    if not @isDayMeasurementsFill(dayObj)
      day = moment(dayObj.courseDayDate).format('D')
      if @Notifications.dayNotices[day]?
        weekDayDataNotice = @Notifications.dayNotices[day].filter (dayNotice) =>
          return dayNotice.type == 'day_data'
        if weekDayDataNotice.length > 0
          @Notifications.Notice.update  { userId: @user.id, noticeId: weekDayDataNotice[0].id }, {}, (data) =>
            @Notifications.dayNotices[day].splice(_.findIndex(@Notifications.dayNotices[day], {id: data.id}), 1)
            @Notifications.notices.splice(_.findIndex(@Notifications.notices, {id: data.id}), 1)

        weekDayDataFrontNotice = @Notifications.dayNotices[day].filter (dayNotice) =>
          return dayNotice.type == 'day_data_front'
        if weekDayDataFrontNotice.length > 0
          @Notifications.dayNotices[day].splice(_.findIndex(@Notifications.dayNotices[day], {type: 'day_data_front'}), 1)

  isDayNotice: (type) =>
    switch type
      when 'day_data' then return true
      when 'day_timetable' then return true
      else return false

  isDayMeasurementsFill: (userDay) =>
    return not userDay.courseDayDate? or
      not userDay.hungerLevel? or
      not userDay.mood? or
      not userDay.numberOfHits? or
      not userDay.waterIntake? or
      not userDay.weight? or
      not userDay.cravingsLevel? or
      (@$rootScope.userCourse.trackGlucoseLevels and not userDay.bloodGlucoseLevel?) or
      (@$rootScope.userCourse.trackSmokeCraving and not userDay.cigarettes?)

  inspireMe: =>
    @$scope.isLoading = true
    @Course.Inspire.me { userId: @user.id, courseId: @$rootScope.userCourse.id }, {}, (data) =>
      @$scope.isLoading = false
      @getUserDays(true)

  disableInspire: () =>
    currentWeekDayNumber = parseInt(@currentMoment.format('d'))
    return currentWeekDayNumber < 1

  isPastDay: (courseDayDate) =>
    currentDay = moment()
    day = moment(courseDayDate)
    if currentDay.diff(day, 'days') > 0
      true
    else
      false

  openMealModal: (day, index) =>
    scopeModal = @$rootScope.$new()
    scopeModal.day = day
    scopeModal.timetableItemIndex = index
    # open
    @$modal.open({
        templateUrl: 'views/modals/foodModalContent.html'
        controller: 'FoodModalCtrl',
        scope: scopeModal
      })

  openWorkoutModal: (day, index) =>
    scopeModal = @$rootScope.$new()
    scopeModal.day = day
    scopeModal.timetableItemIndex = index
    # open
    @$modal.open({
        templateUrl: 'views/modals/gymModalContent.html'
        controller: 'WorkoutsModalCtrl',
        scope: scopeModal
      })

  bindModalSelects: =>
    @$scope.$on 'meal_modal.select', (event, args) =>
      day = args.day
      index = args.index
      meal = args.meal
      newDay = angular.copy(day)
      newDay.timetableItems[index].item = meal

      @saveDay(newDay, true)

    @$scope.$on 'workout_modal.select', (event, args) =>
      day = args.day
      index = args.index
      workout = args.workout
      newDay = angular.copy(day)
      newDay.timetableItems[index].item = workout

      @saveDay(newDay, true)

  dropCallback: (event, ui, day, item, $index) =>
    if day.timetableItems isnt undefined and @dragIndex != $index
      @saveDay(day)
    @draggableDragging = {}
    @droppingOverOut = {}

  setDragging: (event, ui, dayIndex, itemIndex, type) =>
    @draggableDragging[dayIndex] = itemIndex
    if type == 'workout'
      @draggingWorkout = true
    else
      @draggingWorkout = false

  isDragging: (dayIndex, itemIndex) =>
    if @draggableDragging[dayIndex] isnt undefined
      @draggableDragging[dayIndex] == itemIndex
    else
      false

  droppingOver: (event, ui, dayIndex, itemIndex) =>
    @droppingOverOut[dayIndex] = itemIndex

  isDroppingOver: (dayIndex, itemIndex) =>
    if @droppingOverOut[dayIndex] isnt undefined
      @droppingOverOut[dayIndex] == itemIndex
    else
      false

  droppingOut: (event, ui, dayIndex, itemIndex) =>
    @droppingOverOut = {}


Dashboard.$inject = [ '$scope', '$log', 'User', 'Course', 'Day', 'Notifications', '$rootScope', '$translate', '$modal', 'usSpinnerService' ]

angular.module('switchfitApp.dashboard')
  .controller 'DashboardCtrl', Dashboard