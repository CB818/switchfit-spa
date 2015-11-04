'use strict'

###*
 # @ngdoc function
 # @name switchfitApp.controller:AcademyFinalTestCtrl
 # @description
 # # AcademyFinalTestCtrl
 # Controller of the switchfitApp
###
class AcademyFinalTest
  constructor: (@$scope, @Academy, $stateParams, $sce, @$log, @$state, @$location) ->
    moduleId = $stateParams.moduleId
    Academy.get({ module: moduleId }).$promise.then (module) =>
      @topics = {}
      @moduleComplete = true
      module.topics.forEach (topic) =>
        @currentTopic = topic.id
        if topic.status != 'complete'
          @moduleComplete = false
        Academy.Topics.get({ module: module.id, topic: topic.id }).$promise.then (topic) =>
          topic.text = $sce.trustAsHtml(topic.text)
          topic.module = $stateParams.moduleId
          @topics[topic.id] = topic
      @info = module

  checkTopic: (topic) =>
    allRight = true
    moduleId = topic.module
    finalTopic = { questions: {} }
    topic.questions.forEach (question) =>
      #@$log.debug "Question: ", question
      finalTopic.questions[question.id] = {}
      question.answers.forEach (answer) =>
        if question.multipleAnswers
          if (answer.isCorrect and !answer.checked) || (!answer.isCorrect and answer.checked)
            allRight = false
          if answer.checked
            finalTopic.questions[question.id][answer.id] = answer.score
        else
          if question.model == answer.id && !answer.isCorrect
            allRight = false
          if question.model == answer.id
            finalTopic.questions[question.id][answer.id] = answer.score

    #@$log.debug "Final: ", finalTopic

    topic.check = true

    @$log.debug topic

    if !@info.final
      if allRight
        #@$log.debug topic.$save()
        topic.$save().then =>
          @$state.go 'academy.final'
    else
      @Academy.Topics.final({ module: moduleId, topic: topic.id }, finalTopic)
      @$state.go 'academy.final'

    topic.allRight = allRight

  next: ->
    if @info.final
      @$state.go 'academy.final'
    else
      moduleId = @moduleId
      @$scope.allModules.forEach (module, index) =>
        if parseInt(module.id) == parseInt(moduleId)
          @nextModuleIndex = index + 1
      @$state.go 'academy.module', moduleId: @$scope.allModules[@nextModuleIndex].id
      @Academy.finish({ module: moduleId }, {})

AcademyFinalTest.$inject = [ '$scope', 'Academy', '$stateParams', '$sce', '$log', '$state', '$location' ]

angular.module('switchfitApp')
  .controller 'AcademyFinalTestCtrl', AcademyFinalTest
