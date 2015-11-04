'use strict'

###*
 # @ngdoc function
 # @name switchfitApp.controller:StatisticsWeightWaterFitnessCtrl
 # @description
 # # StatisticsWeightWaterFitnessCtrl
 # Controller of the switchfitApp
###
class StatisticsCigarettesGlucose
  constructor: (@$scope, @$rootScope, @usSpinnerService, @Course) ->
    @height = 200
    @weeks = {}
    @glucoseData = {}
    @cigarettesData = {}
    @cigarettesGlucoseData = {
      glucoseData: @glucoseData
      cigarettesData: @cigarettesData
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
        @glucoseData[date.format('YYYY-MM-DD')] = 3
        @cigarettesData[date.format('YYYY-MM-DD')] = 0
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
          # glucose data
          if @glucoseData[courseDayDate.format('YYYY-MM-DD')] isnt undefined and
            day.bloodGlucoseLevel isnt null and day.bloodGlucoseLevel > 3
              @glucoseData[courseDayDate.format('YYYY-MM-DD')] = day.bloodGlucoseLevel
          # cigarettes data
          if @cigarettesData[courseDayDate.format('YYYY-MM-DD')] isnt undefined and
            day.cigarettes isnt null and day.cigarettes > 0
              @cigarettesData[courseDayDate.format('YYYY-MM-DD')] = day.cigarettes
#        @cigarettesGlucoseData.glucoseData = @glucoseData
        @$scope.isLoading = false
        @usSpinnerService.stop('chart-loader')

        # active chart
        @$scope.activeChart = 'cigarettes'

StatisticsCigarettesGlucose.$inject = [ '$scope', '$rootScope', 'usSpinnerService', 'Course' ]

angular.module('switchfitApp')
.controller 'StatisticsCigarettesGlucoseCtrl', StatisticsCigarettesGlucose