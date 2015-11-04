'use strict'

###*
 # @ngdoc function
 # @name switchfitApp.controller:QAQuestionFormCtrl
 # @description
 # # QAQuestionFormCtrl
 # Controller of the switchfitApp
###
class QAQuestionFormCtrl
  constructor: (@$scope, @QA, @$timeout) ->
    @QA.Categories.get().$promise.then (categories) =>
      @$scope.categories = categories

      @init = {
        category: null
        title: null
        text: null
      }

      @$scope.formQuestion = angular.copy(@init)

      @$scope.submit = (questionForm) =>
        @addQuestion()

      @$scope.reset = () =>
        @$scope.formQuestion = angular.copy(@init)

      @$scope.successfullyAdded = false
      @$scope.isLoading = false

      @$scope.disabled = () =>
        return not @$scope.formQuestion.category? or
          not @$scope.formQuestion.title? or
          not @$scope.formQuestion.text?
  addQuestion: =>
    @loading(true)
    @$scope.errors = []
    @$scope.errorsFields = {}
    @QA.add {}, @$scope.formQuestion, (data) =>
      @QA.questions.unshift(data)
      @$scope.reset()
      @$scope.successfullyAdded = true
      @$timeout(=>
        @$scope.successfullyAdded = false
        return
      , 3000
      )
      @loading(false)
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
      @$scope.reset()
      @loading(false)
  loading: (state) =>
    if (state)
      @$scope.isLoading = true
    else
      @$scope.isLoading = false

QAQuestionFormCtrl.$inject = [ '$scope', 'QA', '$timeout']

angular.module('switchfitApp.qa')
.controller 'QAQuestionFormCtrl', QAQuestionFormCtrl