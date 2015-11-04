'use strict'

###*
 # @ngdoc service
 # @name switchfitApp.qa
 # @description
 # # qa
 # Service in the switchfitApp.
###
angular.module('switchfitApp')
  .service 'QA', (API, $resource, $stateParams) ->
    QA = $resource API.path('questions'), {}, {
      get:
        isArray: true
      add:
        method: 'POST'
    }
    QA.Categories = $resource API.path('questions/categories'), {}, {
      get:
        isArray: true
    }
    QA.Question = $resource API.path('questions/:questionId'), {}, {}
    QA.Answer = $resource API.path("questions/:questionId/answers"), {}, {
      add:
        method: 'POST'

    }
    QA.Vote = $resource API.path("questions/:questionId/votes"), {}, {
      add:
        method: 'POST'
    }
    QA.questions = []
    QA.question = {}
    QA.getPagedQuestions = (slice = true) =>
      categoryId = $stateParams.categoryId

      start = (QA.currentPage - 1) * QA.itemPerPage
      end = QA.currentPage * QA.itemPerPage

      questions = []
      if !(categoryId?)
        questions = QA.questions
      else
        questions = QA.questions.filter (question) =>
          question.category.id == parseInt(categoryId)
      if slice
        questions.slice(start, end)
      else
        questions

    QA.currentPage = 1
    QA.itemPerPage = 10
    QA
