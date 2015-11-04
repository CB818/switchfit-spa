'use strict'

angular.module('switchfitApp.qa', ['ui.router'])
.config ($stateProvider) ->
  $stateProvider
  .state 'qa',
    url: '/qa',
    templateUrl: 'views/qa.html'
    controller: 'MainCtrl'
  .state 'qa.question',
    url: '/:questionId',
    templateUrl: 'views/qa/post.html',
    controller: 'QAQuestionCtrl as question'
  .state 'qa.category',
    url: '/category/:categoryId'

###*
 # @ngdoc function
 # @name switchfitApp.controller:QaCtrl
 # @description
 # # QaCtrl
 # Controller of the switchfitApp
###
class QACtrl
  constructor: (@$scope, @QA) ->
    @QA.get().$promise.then (questions) =>
      @QA.questions = questions

      @$scope.getQuestions = () =>
        @QA.questions

      @$scope.getPagedQuestions = () =>
        @QA.getPagedQuestions()


QACtrl.$inject = [ '$scope', 'QA']

angular.module('switchfitApp.qa')
.controller 'QACtrl', QACtrl

class QAPagination
  constructor: (@$scope, @QA, $location) ->
    @QA.currentPage = 1

    @QA.get().$promise.then =>
      @$scope.totalItems = @QA.getPagedQuestions(false).length
      @$scope.currentPage = @QA.currentPage

      @$scope.pageChanged = () =>
        @QA.currentPage = @$scope.currentPage

      @$scope.maxSize = 5;
      @$scope.itemPerPage = @QA.itemPerPage

QAPagination.$inject = [ '$scope', 'QA', '$location']

angular.module('switchfitApp.qa')
.controller 'QAPaginationCtrl', QAPagination