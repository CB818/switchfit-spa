'use strict'

###*
 # @ngdoc function
 # @name switchfitApp.controller:WarmupCtrl
 # @description
 # # WarmupCtrl
 # Controller of the switchfitApp
###
class Warmup
  constructor: (@$scope, @Course, @User, @Content, @$rootScope, @$cookies, @$sce) ->
    @$rootScope.currentUser.$promise.then =>
      @currentUser = @$rootScope.currentUser
      @init()
  init: =>
    @$scope.srefPrefix = ''
    @$scope.srefPrefix = 'demo.' if @$rootScope.isDemo

    @$tasksCnt = 5
    @$scope.warmup = []
    @checkWarmupCompleted()
    
    @$scope.checkTask = ($num) =>
      if @$scope.warmup[$num]
        @$scope.completeTask($num)
      else
        delete @$cookies['task_'+$num]

    @$scope.completeTask = ($num) =>
      @$cookies['task_'+$num] = 'done'
      @checkWarmupCompleted()

  checkWarmupCompleted: () =>
    @$completedTasksCnt = 0
    for i in [1..@$tasksCnt]
      @$scope.warmup[i] = @$cookies['task_'+i] == 'done'
      if @$scope.warmup[i]
        @$completedTasksCnt++
    if @$completedTasksCnt == @$tasksCnt
      @completeWarmup()

  completeWarmup: () =>
    @$scope.errors = []
    @Course.Warmup.update {userId: @currentUser.id, courseId: @$rootScope.userCourse.id}, {}, (data) =>
      if data.warmupCompleted
        @$rootScope.showWarmup = false
        delete @$cookies['warmup_modal_showed']
        for i in [1..@$tasksCnt]
          delete @$cookies['task_'+i]

Warmup.$inject = [ '$scope', 'Course', 'User', 'Content', '$rootScope', '$cookies', '$sce']

angular.module('switchfitApp').controller 'WarmupCtrl', Warmup
