'use strict'

class ModalMotivation
  constructor: (@$scope, @$rootScope) ->
    @$rootScope.currentUser.$promise.then =>
      @$scope.whatDoIfMotivationIsLow = @$rootScope.userCourse.whatDoIfMotivationIsLow
      @$scope.whatMotivatesYouMost = @$rootScope.userCourse.whatMotivatesYouMost
      @$scope.whoIsYourBestContactForMotivation = @$rootScope.userCourse.whoIsYourBestContactForMotivation

ModalMotivation.$inject = [ '$scope', '$rootScope']

angular.module('switchfitApp.diary')
  .controller 'ModalMotivationCtrl', ModalMotivation
