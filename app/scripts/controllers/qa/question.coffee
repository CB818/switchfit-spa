'use strict'

###*
 # @ngdoc function
 # @name switchfitApp.controller:QaQuestionCtrl
 # @description
 # # QaQuestionCtrl
 # Controller of the switchfitApp
###
class QAQuestionCtrl
  constructor: (@$scope, @QA, $stateParams, @$rootScope, @$timeout) ->
    @$rootScope.qaAnswerFormVisible = false
    @questionId = $stateParams.questionId
    @QA.question = @QA.Question.get({questionId : @questionId})
    @QA.question.$promise.then (question) =>
      @$scope.question = @QA.question

      @$scope.showAnswerForm = () =>
        @$rootScope.qaAnswerFormVisible = true
        @$timeout(->
          scrollTop = angular.element('#answer-form').offset().top
          angular.element('html,body').stop().animate({
            'scrollTop': scrollTop - 20
          }, 500, 'swing')
        )
      @$scope.vote = () =>
        @addVote()
  addVote: () =>
    @$scope.errors = []
    @$scope.errorsFields = {}
    @QA.Vote.add {questionId: @questionId}, {}, (data) =>
      @QA.question.votesCnt = @QA.question.votesCnt + 1
      @QA.question.canVote = false
      return
    , (data) =>
      if data.data && data.data.errors && data.data.errors.children
        for field, error of data.data.errors.children
          if error.errors
            for err in error.errors
              if !@$scope.errorsFields[field]?
                @$scope.errorsFields[field] = []
              @$scope.errorsFields[field].push(err)

      if @$scope.errors.length == 0
        @$scope.errors.push('Something wrong!')

QAQuestionCtrl.$inject = [ '$scope', 'QA', '$stateParams', '$rootScope', '$timeout']

angular.module('switchfitApp.qa').controller 'QAQuestionCtrl', QAQuestionCtrl