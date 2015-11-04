'use strict'

angular.module('switchfitApp.academy', ['ui.router'])
.config ($stateProvider) ->
  $stateProvider
    .state 'academy',
      url: '/academy',
      templateUrl: 'views/academy.html'
      controller: 'AcademyCtrl as academy'
    .state 'academy.final',
      url: '/final',
      templateUrl: 'views/academy/final-test-results.html'
      controller: 'AcademyFinalCtrl as final'
    .state 'academy.final-test',
      url: '/final-test/:moduleId',
      templateUrl: 'views/academy/final-test.html'
      controller: 'AcademyFinalTestCtrl as module'
    .state 'academy.module',
      url: '/:moduleId',
      templateUrl: 'views/academy/module.html'
      controller: 'AcademyModuleCtrl as module'
    .state 'demo.academy',
      url: '/academy',
      templateUrl: 'views/demo/academy.html'
      controller: 'DemoAcademyCtrl as academy'
    .state 'demo.academy.module',
      url: '/:moduleId',
      templateUrl: 'views/demo/module.html'
      controller: 'DemoAcademyModuleCtrl as module'

###*
 # @ngdoc function
 # @name switchfitApp.controller:AcademyCtrl
 # @description
 # # AcademyCtrl
 # Controller of the switchfitApp
###
class Academy
  constructor: (@$rootScope, @$scope, @Academy, @$timeout) ->
    @$rootScope.currentUser.$promise.then =>
      @$rootScope.allModules.$promise.then (modules) =>
        @$scope.unpayed = false
        @levelCheckpoint = 50
        @modules = modules
        $scope.finalModule = []
        $scope.progressModules = []
        $scope.totalScore = @modules.map((module) -> module.score)
          .reduce(((l, r) -> l + r), 0)
        $scope.totalComplete = @modules.filter((module) -> module.status == 'complete')
          .map((module) -> module.score)
          .reduce(((l, r) -> l + r), 0)
        $scope.totalCompleteLevel = () =>
          return Math.floor(@$scope.totalComplete / @levelCheckpoint)
        $scope.toNextLevel = () =>
          return @levelCheckpoint - (@$scope.totalComplete % @levelCheckpoint)
        $scope.modulesCompleted = @modules.filter((module) -> module.status == 'complete')

        moduleInProgress = _.find(@modules, (module) => module.status == 'in_progress')
        if moduleInProgress
          Academy.get({ module: moduleInProgress.id }).$promise.then (mod) =>
            topicsScore = mod.topics.filter((topic) -> topic.status == 'complete')
              .map((topic) -> topic.score)
              .reduce(((l, r) -> l + r), 0)
            @$scope.totalComplete += topicsScore
        else
          lastCompleteIndex = null
          @modules.forEach (module, index) =>
            if module.status == 'complete'
              lastCompleteIndex = index

        @currentModule = _.find(@modules, (module) => module.status == 'incomplete' || module.status == 'in_progress')

        if lastCompleteIndex isnt null and (@modules.length >= lastCompleteIndex + 2)
          @modules[lastCompleteIndex + 1].status = 'in_progress'
        else if lastCompleteIndex is null
          @modules[0].status = 'in_progress'

        @modules.forEach (module) ->
          if module.final
            $scope.finalModule.push module

        @modules.forEach (module, index) =>
          module.preCurrent = false
          if module.status == 'in_progress'
            $scope.progressModules.push module
            if @modules[index - 1] isnt undefined
              @modules[index - 1].preCurrent = true

    window.Intercom('trackEvent', 'page-visit-academy')


Academy.$inject = [ '$rootScope', '$scope', 'Academy', '$timeout' ]

angular.module('switchfitApp.academy')
  .controller 'AcademyCtrl', Academy

class AcademyCurrent
  constructor:(@$scope, @Academy) ->
    @Academy.Current.get().$promise.then (result) =>
      $scope.academyCurrent = result
    , (err) =>
      console.log(err)

AcademyCurrent.$inject = [ '$scope', 'Academy'];
angular.module('switchfitApp.academy').controller 'AcademyCurrentCtrl', AcademyCurrent