'use strict'

###*
 # @ngdoc function
 # @name switchfitApp.controller:StatisticsWeightWaterFitnessCtrl
 # @description
 # # StatisticsWeightWaterFitnessCtrl
 # Controller of the switchfitApp
###
class StatisticsWeightWaterFitness
  constructor: (@$scope, @$rootScope, @usSpinnerService, @Course) ->
    @startWeight = 0
    @maxOffset = 10
    @height = 200
    @weeks = {}
    @waterData = {}
    @fitnessMarkData = {}
    @$scope.activeChart = null

    @$scope.isLoading = true
    @$scope.currentWeekNumber = moment().format('W')

    @$rootScope.currentUser.$promise.then (user) =>
      @userCourse = @$rootScope.userCourse
      @startWeight = @userCourse.currentWeight
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
          @weeks[weekNumber] = {days: {}, startWeight: @startWeight, endWeight: @startWeight, weightOffsets: []}
        @weeks[weekNumber]['days'][dayWeekNumber] = {courseDayDate: date.format('YYYY-MM-DD'), weight: null}
        @waterData[date.format('YYYY-MM-DD')] = 0
        @fitnessMarkData[weekNumber] = 0
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
            if day.weight
              @weeks[weekNumber]['endWeight'] = day.weight
          # water data
          if @waterData[courseDayDate.format('YYYY-MM-DD')] isnt undefined and day.waterIntake isnt null and day.waterIntake > 0
            @waterData[courseDayDate.format('YYYY-MM-DD')] = day.waterIntake

        # fill week weight data
        prevWeekNumber = null
        for weekNumber,week of @weeks
          # fill startWeight for every week
          weekDayWithRealWeight = false
          for dayWeekNumber,day of week.days
            if prevWeekNumber isnt null and @weeks[prevWeekNumber] isnt undefined
              week.startWeight = @weeks[prevWeekNumber]['endWeight']
            if day.weight isnt null
              weekDayWithRealWeight = true
            if parseInt(dayWeekNumber) == 7 and weekDayWithRealWeight
              prevWeekNumber = angular.copy(weekNumber)
            else if parseInt(dayWeekNumber) == 7 and weekDayWithRealWeight is false
              week.endWeight = week.startWeight
          # fill weight offsets for every days of week
          for dayWeekNumber,day of week.days
            courseDayDate = moment(day.courseDayDate)
            active = Math.ceil(@currentMoment.diff(courseDayDate, 'days', true)) >= 0
            if day.weight isnt null and day.weight > 0
              week.weightOffsets.push({weight: day.weight, offset: day.weight - week.startWeight, active: active})
            else
              week.weightOffsets.push({weight: null, offset: 0, active: active})
#        console.log(@weeks)

        @$rootScope.weeks.$promise.then (weeks) =>
          for week in weeks
            if week.runningTimeScore >= 0 and week.pushupsScore >= 0 and @fitnessMarkData[week.number] isnt undefined
              weekNumber = week.number
              if @currentWeekNumber > 40 and Number(weekNumber) < 10
                weekNumber = Number(weekNumber) + 52
              @fitnessMarkData[week.number] = (week.runningTimeScore + week.pushupsScore)
          @$scope.isLoading = false
          @usSpinnerService.stop('chart-loader')
          @$scope.activeChart = 'week'

#          console.log(@fitnessMarkData)

    @$scope.getWeekTopPosition = (newValue) =>
      if newValue == @startWeight
        return -(@height/2)
      else
        weightDiff = newValue - @startWeight
        if weightDiff < -10
          weightDiff = -10
        else if weightDiff  > 10
          weightDiff = 10
        offset = -((weightDiff*(@height/2))/@maxOffset)

        return -(@height/2) + offset

StatisticsWeightWaterFitness.$inject = [ '$scope', '$rootScope', 'usSpinnerService', 'Course' ]

angular.module('switchfitApp')
.controller 'StatisticsWeightWaterFitnessCtrl', StatisticsWeightWaterFitness