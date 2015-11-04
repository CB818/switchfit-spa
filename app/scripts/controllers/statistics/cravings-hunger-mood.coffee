'use strict'

###*
 # @ngdoc function
 # @name switchfitApp.controller:StatisticsWeightWaterFitnessCtrl
 # @description
 # # StatisticsWeightWaterFitnessCtrl
 # Controller of the switchfitApp
###
class StatisticsCravingsHungerMood
  constructor: (@$scope, @$rootScope, @usSpinnerService, @Course) ->
    @height = 200
    @weeks = {}
    @cravingsData = {}
    @hungerData = {}
    @moodData = {}
    @cravingsHungerMoodData = {
      cravingsData: @cravingsData
      hungerData: @hungerData
      moodData: @moodData
    }
    @$scope.activeChart = null
    @$scope.subData = {
      activeChart: null
    }

    @$scope.isLoading = true
    @$scope.currentWeekNumber = moment().format('W')

    @$rootScope.currentUser.$promise.then (user) =>
      @userCourse = @$rootScope.userCourse
      dateFrom = moment(@userCourse.course.dateFrom, 'YYYY-MM-DD')
      dateTo = moment(@userCourse.course.dateTo, 'YYYY-MM-DD')
      date = angular.copy(dateFrom)
      @currentMoment = moment()
      @currentWeekNumber = Number(@currentMoment.format('W'))

      # empty graph data
      while Math.ceil(dateTo.diff(date, 'days', true)) >= 0
        weekNumber = date.format('W')
        if @currentWeekNumber > 40 and Number(weekNumber) < 10
          weekNumber = Number(weekNumber) + 52
        dayWeekNumber = date.format('E')
        if @weeks[weekNumber] is undefined
          @weeks[weekNumber] = {days: {}}
        @weeks[weekNumber]['days'][dayWeekNumber] = {courseDayDate: date.format('YYYY-MM-DD'), weight: null}
        @cravingsData[date.format('YYYY-MM-DD')] = 0
        @hungerData[date.format('YYYY-MM-DD')] = 0
        @moodData[date.format('YYYY-MM-DD')] = 0
        date.add(1, 'days')

      @$rootScope.days.$promise.then (days) =>
        # fill graph data
        for day in days
          courseDayDate = moment(day.courseDayDate)
          weekNumber = courseDayDate.format('W')
          if @currentWeekNumber > 40 and Number(weekNumber) < 10
            weekNumber = Number(weekNumber) + 52
          dayWeekNumber = courseDayDate.format('E')
          # week data
          if @weeks[weekNumber] isnt undefined and @weeks[weekNumber]['days'][dayWeekNumber] isnt undefined
            @weeks[weekNumber]['days'][dayWeekNumber] = day
          # cravings data
          if @cravingsData[courseDayDate.format('YYYY-MM-DD')] isnt undefined and
            day.cravingsLevel isnt null and day.cravingsLevel > 0
              @cravingsData[courseDayDate.format('YYYY-MM-DD')] = day.cravingsLevel
          # hunger data
          if @hungerData[courseDayDate.format('YYYY-MM-DD')] isnt undefined and
            day.hungerLevel isnt null and day.hungerLevel > 0
              @hungerData[courseDayDate.format('YYYY-MM-DD')] = day.hungerLevel
          # mood data
          if @moodData[courseDayDate.format('YYYY-MM-DD')] isnt undefined and
            day.mood isnt null and day.mood > 0
              @moodData[courseDayDate.format('YYYY-MM-DD')] = day.mood

        @$scope.isLoading = false
        @usSpinnerService.stop('chart-loader')

        # active chart
        @$scope.activeChart = 'hunger'

StatisticsCravingsHungerMood.$inject = [ '$scope', '$rootScope', 'usSpinnerService', 'Course' ]

angular.module('switchfitApp')
.controller 'StatisticsCravingsHungerMoodCtrl', StatisticsCravingsHungerMood
