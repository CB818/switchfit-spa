'use strict'

class ModalWeeklyData
  constructor: (@$scope, @Course, @User, @$rootScope, @$modalInstance, @Notifications) ->
    noticeMoment = moment(@$scope.notice.createdAt);

    noticeWeekNumber = noticeMoment.format('W')
    weeklyDataMoment = noticeMoment.subtract('weeks', noticeWeekNumber - @$scope.week)
    firstDay = weeklyDataMoment.add('weeks',1).startOf('isoWeek')
    detoxDays = {}
    wDays = [
      'frontend.days.monday',
      'frontend.days.tuesday',
      'frontend.days.wednesday',
      'frontend.days.thursday',
      'frontend.days.friday',
      'frontend.days.saturday',
      'frontend.days.sunday'
    ]
    for i in [2...6]
      weekDay = firstDay.day(i)
      detoxDays[weekDay.format('DD.MM.YYYY')] = wDays[i-1] # weekDay.format('dddd')

    @$scope.detoxDays = detoxDays
    @$scope.runningTime = {
      min: null,
      sec: null
    }
    @$scope.runningTimeSec = null
    @$scope.weeklyData = {
      waist: null
      bust: null
      hips: null
      arms: null
      legs: null
      runningTime: null
      pushupsNumber: null
      situpsNumber: null
      squatJumpsNumber: null
      nextWeekDetoxDay: null
      nextWeekGoalWeight: null
    }

    @$rootScope.currentUser.$promise.then =>
      @currentUser = @$rootScope.currentUser
      @init()
    @$scope.isLoading = false
  init: =>
    courseDateFrom = moment(@$rootScope.userCourse.course.dateFrom, 'YYYY-MM-DD')
    @$scope.currentCourseWeek = (@$scope.week - courseDateFrom.format('W')) + 1
    @$scope.submit = (weeklyDataForm) =>
      @addWeeklyData()
    @$scope.totalBodyMeasurements = () =>
      return @$scope.weeklyData.waist +
        @$scope.weeklyData.bust +
        @$scope.weeklyData.hips +
        @$scope.weeklyData.arms +
        @$scope.weeklyData.legs

  addWeeklyData: =>
    @$scope.isLoading = true
    @$scope.errors = []
    @$scope.errorsFields = {}
    data = @$scope.weeklyData
    if @$scope.runningTime.min >= 0 and @$scope.runningTime.sec >= 0
      data.runningTime = parseInt(@$scope.runningTime.min) * 60 + parseInt(@$scope.runningTime.sec)
    @Course.Week.update {userId: @currentUser.id, courseId: @$rootScope.userCourse.id, number: @$scope.week}, @$scope.weeklyData, (data) =>
      # mark notice as read
      if @$scope.notice.id isnt undefined
        @Notifications.Notice.update  { userId: @currentUser.id, noticeId: @$scope.notice.id }, {}, (data) =>
          @Notifications.notices.splice(_.findIndex(@Notifications.notices, {id: data.id}), 1)
          @$scope.$close()
          @$scope.isLoading = false
      else
        @$scope.$close()
        @$scope.isLoading = false
      @$rootScope.showWeeklyButton = false
    , (data) =>
      if data.data && data.data.errors && data.data.errors.children
        for field, error of data.data.errors.children
          if error.errors
            for err in error.errors
              if !@$scope.errorsFields[field]?
                @$scope.errorsFields[field] = []
              @$scope.errorsFields[field].push(err)

      if @$scope.errors.length == 0
        @$scope.errors.push('Something wrong!')
      @$scope.isLoading = false

ModalWeeklyData.$inject = [ '$scope', 'Course', 'User', '$rootScope', '$modalInstance', 'Notifications']

angular.module('switchfitApp').controller 'ModalWeeklyDataCtrl', ModalWeeklyData