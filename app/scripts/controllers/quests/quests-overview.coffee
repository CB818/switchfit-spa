'use strict'

###*
 # @ngdoc function
 # @name switchfitApp.controller:QodsOverviewCtrl
 # @description
 # # QodOverviewCtrl
 # Controller of the switchfitApp
###
class QodsOverview
  constructor: (@$scope, @QodData) ->
    previousQuests = @QodData.AllPreviousQuests.get()
    previousQuests.$promise.then (result) =>
      @$scope.quests = result

    @QodData.get().$promise.then (result)  =>
      undefined
    , (err) =>
      if err.status == 470
        @$scope.limitExceeded = true

    window.Intercom('trackEvent', 'page-visit-quests')

QodsOverview.$inject = ['$scope', 'QodData']
angular.module('switchfitApp')
  .controller 'QodsOverviewCtrl', QodsOverview