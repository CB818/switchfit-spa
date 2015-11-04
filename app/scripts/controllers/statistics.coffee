'use strict'
angular.module('switchfitApp.statistics', ['ui.router'])
.config ($stateProvider) ->
  $stateProvider
  .state 'statistics',
    url: '/statistics',
    templateUrl: 'views/statistics.html'
    controller: 'StatisticsCtrl as statistics'
  .state 'statistics.weightWaterFitness',
    url: '/weight-water-fitness',
    templateUrl: 'views/statistics/weight-water-fitness.html'
    controller: 'StatisticsWeightWaterFitnessCtrl as stat'
  .state 'statistics.cravingsHungerMood',
    url: '/cravings-hunger-mood',
    templateUrl: 'views/statistics/cravings-hunger-mood.html'
    controller: 'StatisticsCravingsHungerMoodCtrl as stat'
  .state 'statistics.cigarettesGlucose',
    url: '/cigarettes-glucose',
    templateUrl: 'views/statistics/cigarettes-glucose.html'
    controller: 'StatisticsCigarettesGlucoseCtrl as stat'

class Statistics
  constructor: (@$scope, @$log, @Course, @$rootScope, @Day) ->

Statistics.$inject = [ '$scope', '$log', 'Course', '$rootScope', 'Day' ]

angular.module('switchfitApp.statistics')
.controller 'StatisticsCtrl', Statistics