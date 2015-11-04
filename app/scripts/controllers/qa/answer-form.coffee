'use strict'

###*
 # @ngdoc function
 # @name switchfitApp.controller:QAAnswerFormCtrl
 # @description
 # # QAAnswerFormCtrl
 # Controller of the switchfitApp
###
class QAAnswerFormCtrl
  constructor: (@$scope, @QA, @$timeout, @$rootScope) ->
    @QA.question.$promise.then (question) =>
      @init = {
        text: null
      }

      @$scope.formAnswer = angular.copy(@init)

      @$scope.submit = (answerForm) =>
        @addAnswer()

      @$scope.reset = () =>
        @$scope.formAnswer = angular.copy(@init)

      @$scope.isLoading = false

      @$scope.disabled = () =>
        not @$scope.formAnswer.text

  addAnswer: =>
    @loading(true)
    @$scope.errors = []
    @$scope.errorsFields = {}
    @QA.Answer.add {questionId: @QA.question.id}, @$scope.formAnswer, (data) =>
      @QA.question.answers.push(data)
      @$scope.reset()
      @$rootScope.qaAnswerFormVisible = false
      @loading(false)
      @$scope.showForm = false
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
      console.log(@$scope.errorsFields)
      @$scope.reset()
      @loading(false)
  loading: (state) =>
    if (state)
      @$scope.isLoading = true
    else
      @$scope.isLoading = false

QAAnswerFormCtrl.$inject = [ '$scope', 'QA', '$timeout', '$rootScope']

angular.module('switchfitApp.qa').controller 'QAAnswerFormCtrl', QAAnswerFormCtrl