'use strict'

###*
 # @ngdoc function
 # @name switchfitApp.controller:QaMenuCtrl
 # @description
 # # QaMenuCtrl
 # Controller of the switchfitApp
###
class QAMenuCtrl
  constructor: (@$scope, @QA, @$location) ->
    @QA.Categories.get().$promise.then (categories) =>
      @$scope.categories = categories
      @$scope.isActive = (path) =>
        return (path == @$location.path())


QAMenuCtrl.$inject = [ '$scope', 'QA', '$location']

angular.module('switchfitApp.qa')
.controller 'QAMenuCtrl', QAMenuCtrl
