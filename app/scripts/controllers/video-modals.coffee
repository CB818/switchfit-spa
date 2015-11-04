'use strict'

###*
 # @ngdoc function
 # @name switchfitApp.controller:VideoModalsCtrl
 # @description
 # # VideoModalsCtrl
 # Controller of the switchfitApp
###
class VideoModals
  constructor: (@$scope, @Course, @User, @Content, @$rootScope, @$cookies, @$sce) ->
    @$rootScope.currentUser.$promise.then =>
      @currentUser = @$rootScope.currentUser
      @init()
  init: =>
    @$scope.srefPrefix = ''
    @$scope.srefPrefix = 'demo.' if @$rootScope.isDemo

VideoModals.$inject = [ '$scope', 'Course', 'User', 'Content', '$rootScope', '$cookies', '$sce']

angular.module('switchfitApp').controller 'VideoModalsCtrl', VideoModals
