'use strict'

class App
  constructor: (@$modal, @$log, @$location, @$cookies, @$rootScope, @User, @Course, @Day, @$translate, @Academy, @$state, @$interval) ->
    if !(@$cookies.switchfit_sessid)
      @route('/app-login')
    resetting = false

    if @$location.path().match(/^\/app-resetting/)
      resetting = true

    if window.location.hash and window.location.hash == '#_=_'
      @$location.hash('')

    angular.element('body').on('click', '.menu-trigger', () =>
      angular.element('body').toggleClass('mobile-menu-open')
      undefined
    )

    @$rootScope.userLoaded = false
    @$rootScope.intercomLoaded = false
    @$rootScope.$on '$stateChangeSuccess', =>
      pieces = @$location.path().split('/')
      piecesLength = pieces.length
      @isDemo = (pieces[1] == 'demo')
      @moduleName = pieces[1]
      @moduleName = pieces[2] if @isDemo and (piecesLength > 2)
      @moduleName = 'dashboard' if pieces[1] == ''
      @submoduleName = ''
      @submoduleName = pieces[2] if (piecesLength > 2)
      @submoduleName = pieces[3] if @isDemo and (piecesLength > 3)
      #@$log.debug "Module name: ", @moduleName
      @$rootScope.openModal = @openModal
      @$rootScope.isDemo = @isDemo
      @$rootScope.moduleName = @moduleName
      @$rootScope.submoduleName = @submoduleName
      # Intercom upd ate trigger
      @updateIntercom()
      angular.element('body').removeClass('mobile-menu-open')
      @$rootScope.allModules = @Academy.query()
      @$rootScope.allModules.$promise.then (modules) =>
        @$rootScope.modulesCompleted = modules.filter((module) -> module.status == 'complete')

    @$rootScope.$on '$stateChangeStart', (ev, to, toParams, from, fromParams) =>
      if to.url.match(/^\/app-resetting/)
        resetting = true

      if !(@$rootScope.currentUser?) and !resetting
        @init()
      else if (!@$rootScope.userLoaded) and !resetting
        @init()
      else if !resetting and (!@checkRole('ROLE_USER_ACTIVE_COURSE', @$rootScope.currentUser.roles) or moment().diff(moment(@$rootScope.userCourse.course.dateFrom, 'YYYY-MM-DD'), 'hours') <= 0)
        @route('/access-denied')
      else if !resetting and !@checkRole('ROLE_USER_ACTIVE_COURSE', @$rootScope.currentUser.roles) and !@$rootScope.isDemo
        @route('/demo')

      if !(@$cookies.switchfit_sessid)
        @route('/app-login')

  init: =>
    # log user activities
    log = 0
    if @$cookies.switchfit_last_user_request
      lastUserRequestMoment = moment(@$cookies.switchfit_last_user_request)
      currentMoment = moment()
      diff = currentMoment.diff(lastUserRequestMoment, 'minutes')
#      @$log.debug 'User activity diff: ' + diff + ' min'
      # TODO: convert constant (30) to a variable from server
      if diff > 30
        log = 1
    else
      log = 1
    user = @User.get { userId: 'current', log: log }
    @$rootScope.currentUser = user

    user.$promise.then(
      (user) =>
        if (!user?)
          @route('/app-login')

        # locale
        @$rootScope.locale = user.locale
        @$translate.use(@$rootScope.locale)

        # not app user
        if !@checkRole('ROLE_USER_APP', user.roles)
          @route('/app-login')
        # user course
        userCourse = user.activeUserCourse
        # angular.element()
        if userCourse.isPaid == false && userCourse.paymentUrl && userCourse.paymentFreeDaysLeft == 0
          window.location.replace(userCourse.paymentUrl);
        @$rootScope.userCourse = userCourse
        @$rootScope.currentWeight = userCourse.currentWeight
        @$rootScope.weekGoalWeight = userCourse.goalWeight

        # redirect to demo
#        if moment().diff(moment(@$rootScope.userCourse.course.dateFrom, 'YYYY-MM-DD'), 'hours') <= 0
#          @route('/demo')

        # temporary redirect to access denied
        if !@checkRole('ROLE_USER_ACTIVE_COURSE', user.roles) or (moment().diff(moment(@$rootScope.userCourse.course.dateFrom, 'YYYY-MM-DD'), 'hours') <= 0)
          @route('/access-denied')

        if !@checkRole('ROLE_USER_ACTIVE_COURSE', user.roles) and !@$rootScope.isDemo
          @route('/demo')

        # app user
        @$rootScope.userLoaded = true
        # momentjs correction timezone
        # moment.updateOffset(user.timezoneOffset)

        @$rootScope.preferredMealCategory = userCourse.preferredMealCategory
        @$rootScope.intoleranceProduct = userCourse.intoleranceProduct
        dateFrom = moment(userCourse.course.dateFrom, 'YYYY-MM-DD')
        dateTo = moment(userCourse.course.dateTo, 'YYYY-MM-DD')
        weeksCount = Math.ceil dateTo.diff dateFrom, 'weeks', true
        @$rootScope.cigaretteStates = ['0-10', '11-20', '21-30', '31-40', '41-50']

        # week data
        startWeekNumber = parseInt(dateFrom.format('W'))
        @$rootScope.modalWeekNumber = currentWeekNumber = parseInt(moment().format('W'))
        # current week
        @$rootScope.fitnessScore = @$rootScope.prevFitnessScore = 0
        @$rootScope.weeks = @Course.Weeks.query({ userId: user.id, courseId: userCourse.id })
        @$rootScope.weeks.$promise.then (weeks) =>
          @$rootScope.showWeeklyButton = false
          copyWeeks = angular.copy(weeks)
          if currentWeekNumber > startWeekNumber
            prevWeekForWeekly = copyWeeks.filter (week) ->
              week.number == currentWeekNumber-1
            if prevWeekForWeekly.length > 0 and (prevWeekForWeekly[0].pushupsScore is null) and (prevWeekForWeekly[0].runningTimeScore is null)
              @$rootScope.modalWeekNumber--
              @$rootScope.showWeeklyButton = true

          currentWeek = copyWeeks.filter (week) ->
            week.number == currentWeekNumber
          if currentWeek.length > 0
            if currentWeek[0].goalWeight > 0
              @$rootScope.weekGoalWeight = currentWeek[0].goalWeight
            if (currentWeek[0].pushupsScore is null) and (currentWeek[0].runningTimeScore is null) and (currentMoment.format("E") >= 5)
              @$rootScope.showWeeklyButton = true
          else
            currentWeekNumber--
            while currentWeekNumber >= startWeekNumber
              prevWeek = copyWeeks.filter (week) ->
                week.number == currentWeekNumber
              if prevWeek.length > 0 and prevWeek[0].goalWeight > 0
                @$rootScope.weekGoalWeight = prevWeek[0].goalWeight
                break
              else
                currentWeekNumber--
          # fitness score
          for week in weeks
            if !(week.runningTimeScore is null) and !(week.pushupsScore is null)
              @$rootScope.fitnessScore = (week.runningTimeScore + week.pushupsScore)
              if week.number < (currentWeekNumber - 1)
                @$rootScope.prevFitnessScore = (week.runningTimeScore + week.pushupsScore)

        # progress days & weeks
        @progressDays = {}
        date = angular.copy(dateFrom)
        while Math.ceil(dateTo.diff(date, 'days', true)) >= 0
          @progressDays[date.format('YYYY-MM-DD')] = {
            showWeight: false
            milestoneClass: ''
            mult: 1
            weight: 0
          }
          date.add(1, 'days')

        @$rootScope.days = @Day.query { userId: user.id, courseId: userCourse.id }
        @$rootScope.days.$promise.then (days) =>
          maxWeightObj = _.max days, (day) -> (if (day.weight?) then day.weight else 1)
          minWeightObj = _.min days, (day) -> (if (day.weight?) then day.weight else 500)
          maxWeight = Math.max(maxWeightObj.weight, @$rootScope.currentWeight)
          minWeight = Math.min(minWeightObj.weight, @$rootScope.currentWeight)
          if minWeight.weight == 500
            minWeight.weight = 0
          @$rootScope.weeks.$promise.then (weeks) =>
            days.forEach (day) =>
              courseDayMoment = moment(day.courseDayDate, 'YYYY-MM-DD')
              if @progressDays[courseDayMoment.format('YYYY-MM-DD')] isnt undefined
                progressDay = @progressDays[courseDayMoment.format('YYYY-MM-DD')]
                if (courseDayMoment.format('E') == '7')
                  progressDay.showWeight = true
                  milestoneWeek = weeks.filter (weekFilter) ->
                    weekFilter.number == parseInt(courseDayMoment.format('W'))
                  if milestoneWeek.length > 0
                    week = milestoneWeek[0]
                    if day.weight <= week.goalWeight
                      progressDay.milestoneClass = 'milestone--success'
                    else
                      progressDay.milestoneClass = 'milestone--danger'
                if day.weight > 0
                  progressDay.weight = day.weight
                  if maxWeight != minWeight
                    progressDay.mult = (day.weight - minWeight) / (maxWeight - minWeight)
            # fix empty day weight
            #prevDayWeight = 0
            prevDayWeight = @$rootScope.currentWeight
            for date, pDay of @progressDays
              dateMoment = moment(date)
              if Math.ceil(dateMoment.diff(currentMoment, 'days', true)) <= 0
                pDay.done = true
                if pDay.weight > 0
                  prevDayWeight = pDay.weight
                if (pDay.weight is null or pDay.weight == 0) and prevDayWeight > 0
                  pDay.weight = prevDayWeight
                  if maxWeight != minWeight
                    pDay.mult = (prevDayWeight - minWeight) / (maxWeight - minWeight)
            @$rootScope.realCurrentWeight = prevDayWeight

            # Intercom init user
            @initIntercom(user)


          # progress weeks
          currentWeek = Math.ceil(moment.duration(currentMoment.diff(moment(dateFrom))).asDays()/7)
          @weeks = []
          for i in [1..weeksCount]
            week = { number: i }
            if i < currentWeek
              week.passed = true
            if i == currentWeek - 1
              week.preCurrent = true
            if i == currentWeek
              week.current = true
            if i == weeksCount
              week.last = true
            @weeks.push week

        @$rootScope.showWarmup = !user.activeUserCourse.warmupCompleted
#        if (@checkRole('ROLE_USER_ACTIVE_COURSE', user.roles) and @$rootScope.showWarmup) and @$cookies['warmup_modal_showed'] != 'true'
#          @$cookies['warmup_modal_showed'] = 'true'
#          @openWarmupModal()
        if @checkRole('ROLE_USER_ACTIVE_COURSE', user.roles)
          @checkWelcomeVideoModal()

        # weekly data modal open by param weekYearNumber in query string
        if @$location.search().weekYearNumber isnt undefined and @$location.search().weekYearNumber?
          @openWeekDataModal(@$location.search().weekYearNumber)

        @$cookies.switchfit_last_user_request = new Date()
    ,
    =>
      @route('/app-login')
    )

    window.Intercom('trackEvent', 'user-logged-in')

    @$interval () =>
      @Course.Ping.get()
    , 60000

  route: (path) =>
    @$location.url(path)

  path: (path) ->
    path

  openModal: (options) =>
    modalOptions = {}
    if options.class?
      modalOptions.windowClass = options.class

    if options.templateUrl?
      modalOptions.templateUrl = options.templateUrl

    if options.size?
      modalOptions.size = options.size

    @$modal.open modalOptions

  openWarmupModal: () =>
    warmupModalOptions =
      templateUrl: "views/modals/warmup-tasks.html"
      class: "modal-md"
      controller: 'WarmupCtrl'
    @$modal.open warmupModalOptions

  openWeekDataModal: (weekNumber) =>
    currentMoment = moment()
    scopeModal = @$rootScope.$new()
    scopeModal.week = weekNumber
    scopeModal.notice = {
      createdAt: currentMoment.format('YYYY-MM-DD')
    }
    @$modal.open({
      templateUrl: 'views/modals/weekly-data.html'
      windowClass: 'modal-md'
      controller: 'ModalWeeklyDataCtrl',
      scope: scopeModal
    })

  checkWelcomeVideoModal: () =>
    if @$cookies['welcome_video_modal_showed'] != 'true'
      @openWelcomeVideoModal()
  openWelcomeVideoModal: () =>
    videoModalOptions =
      templateUrl: "views/modals/video-welcome.html"
      class: "modal-md"
      controller: 'VideoModalsCtrl'
    @$modal.open videoModalOptions
    @$cookies['welcome_video_modal_showed'] = 'true'

  openVideoModal: (pageSlug) =>
    scopeModal = @$rootScope.$new()
    scopeModal.slug = pageSlug
    videoModalOptions =
      templateUrl: "views/modals/video-default.html"
      class: "modal-md"
      controller: 'VideoModalsCtrl'
      scope: scopeModal
    @$modal.open videoModalOptions

  openWeightEditModal: () =>
    scopeModal = @$rootScope.$new()
    weightEditModal =
      templateUrl: "views/modals/weight.html"
      class: "modal-md"
      windowClass: 'measurements-modal weight'
      controller: 'WeightModalsCtrl'
      scope: scopeModal
    @$modal.open weightEditModal

  openMeasurementsEditModal: () =>
    scopeModal = @$rootScope.$new()
    measurementsEditModal =
      templateUrl: "views/modals/measurements.html"
      windowClass: 'measurements-modal'
      class: "modal-md "
      controller: 'MeasurementsModalsCtrl'
      scope: scopeModal
    @$modal.open measurementsEditModal

  checkRole: (role, array) ->
    if array is undefined or array is null
      return -1
    return array.indexOf(role) isnt -1

  initIntercom: (user) ->
    appId = 'dpuxtep9';
    if window.location.hostname == 'app.switchfit.io'
      appId = 'go20t8zg';

    if user.activeUserCourse.paymentUrl
      paymentUrl = 'http://' + window.location.hostname + user.activeUserCourse.paymentUrl + '/' + user.activeUserCourse.id
    else
      paymentUrl = ''

    window.Intercom('boot', {
      app_id: appId,
      email: user.email,
      user_id: user.id,
      name: user.firstname+' '+user.lastname,
      user_hash: user.intercomHash,
      created_at: moment(user.createdAt).format('X'),
      'gender': user.gender,
      'course_id': user.activeUserCourse.course.id,
      'course_title': user.activeUserCourse.course.title,
      'course_start': moment(user.activeUserCourse.course.dateFrom).format('X'),
      'course_finish': moment(user.activeUserCourse.course.dateTo).format('X'),
      'course_day': Math.ceil(moment.duration(moment().diff(moment(user.activeUserCourse.course.dateFrom))).asDays()),
      'start_weight': user.activeUserCourse.currentWeight,
      'current_weight': @$rootScope.realCurrentWeight,
      'goal_weight': user.activeUserCourse.goalWeight,
      'warmup_completed': user.activeUserCourse.warmupCompleted,
      'track_smoking': user.activeUserCourse.trackSmokeCraving,
      'track_glucose': user.activeUserCourse.trackGlucoseLevels,
      'fitness_score': @$rootScope.fitnessScore,
      'payment_course_is_paid': user.activeUserCourse.isPaid,
      'payment_due_date': moment(user.activeUserCourse.paymentDueDate).format('X'),
      'payment_url': paymentUrl,
    })
    @$rootScope.intercomLoaded = true

  updateIntercom: () ->
    if (@$rootScope.intercomLoaded)
      window.Intercom('update')

  goWithReload: (state, params={}) =>
    @$state.go(state, params, {reload: true})

App.$inject = [ '$modal', '$log', '$location', '$cookies', '$rootScope', 'User', 'Course', 'Day', '$translate', 'Academy', '$state', '$interval' ]

angular.module('switchfitApp').controller 'AppCtrl', App