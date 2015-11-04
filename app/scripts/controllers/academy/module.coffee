'use strict'

###*
 # @ngdoc function
 # @name switchfitApp.controller:AcademyModuleCtrl
 # @description
 # # AcademyModuleCtrl
 # Controller of the switchfitApp
###
class AcademyModule
  constructor: (@$scope, @Academy, $stateParams, @$sce, @$log, @$state, @$location, @$rootScope) ->
    @moduleId = $stateParams.moduleId
    Academy.get({ module: @moduleId }).$promise.then (module) =>
      @topics = {}
      @moduleComplete = true
      module.topics.forEach (topic) =>
        if topic.status != 'complete'
          @moduleComplete = false
          topic.open = false
        if topic.status == 'in_progress'
          topic.open = true
          Academy.Topics.get({ module: @moduleId, topic: topic.id }).$promise.then (data) =>
            data.text = @$sce.trustAsHtml(data.text)
            data.module = @moduleId
            @topics[data.id] = data
      @info = module

      @$scope.$watch('module.info.topics', (topics) =>
        topics.forEach (topic) =>
          if topic.open and @topics[topic.id] is undefined
#            @$log.debug "Topic: ", topic
            Academy.Topics.get({ module: @moduleId, topic: topic.id }).$promise.then (data) =>
              data.text = @$sce.trustAsHtml(data.text)
              data.module = @moduleId
              @topics[data.id] = data
      , true)
    , (err) =>
      if err.status == 470
        @$scope.unpayed = true

        @$rootScope.$watch('userCourse.paymentUrl', (paymentUrl) =>
          @$scope.paymentUrl = paymentUrl
        )

    window.Intercom('trackEvent', 'page-visit-academy-module-' + @moduleId)

  checkTopic: (topic) =>
    allRight = true
    showErr = false
    moduleId = @moduleId
    finalTopic = { questions: {} }
    topic.questions.forEach (question) =>
#      @$log.debug "Question: ", question
      finalTopic.questions[question.id] = {}
      question.answers.forEach (answer) =>
        if question.multipleAnswers
          if (answer.isCorrect and !answer.checked) || (!answer.isCorrect and answer.checked)
            allRight = false
          if answer.checked
            finalTopic.questions[question.id][answer.id] = answer.score
        else
          if question.model is undefined
            allRight = false
            showErr = true
          if question.model == answer.id && !answer.isCorrect
            allRight = false
          if question.model == answer.id
            finalTopic.questions[question.id][answer.id] = answer.score

    topic.check = true

    if !@info.final
      if allRight
        #@$log.debug topic.$save()
        topic.$save().then (data) =>
#          @$state.go @$state.$current, null, reload: true
#          @$log.debug "Data: ", data
          @moduleComplete = true
          currentTopicIndex = null
          @$rootScope.globalPoints.$emit('updatePoints');
          @info.topics.forEach (top, index) =>
            if top.id == data.id and data.status == 'complete'
              top.status = 'complete'
              currentTopicIndex = index
              top.open = false
            if top.status != 'complete'
              @moduleComplete = false
              top.open = false

          if @info.topics.length >= currentTopicIndex + 2
            @info.topics[currentTopicIndex + 1].status = 'in_progress'
            @info.topics[currentTopicIndex + 1].open = true

          if data.status == 'complete'
            @$scope.$parent.totalComplete += data.score
    else
      @Academy.Topics.final({ module: moduleId, topic: topic.id }, finalTopic)
      @$rootScope.globalPoints.$emit('updatePoints');
      @$state.go 'academy.final', {}, reload: true

    topic.allRight = allRight
    topic.showErr = showErr

  next: ->
    if @info.final
      @$state.go 'academy.final', {}, reload: true
    else
      moduleId = @moduleId
      @$scope.allModules.forEach (module, index) =>
        if parseInt(module.id) == parseInt(moduleId)
          @nextModuleIndex = index + 1
      if @$scope.allModules[@nextModuleIndex]
        @$state.go 'academy.module', {moduleId: @$scope.allModules[@nextModuleIndex].id}, reload: true
        if @$scope.allModules[@nextModuleIndex].status != 'complete'
          @Academy.finish({ module: moduleId }, {})
      else
        @$state.go 'academy', {}, reload: true
        @Academy.finish({ module: moduleId }, {})

AcademyModule.$inject = [ '$scope', 'Academy', '$stateParams', '$sce', '$log', '$state', '$location', '$rootScope'  ]

angular.module('switchfitApp')
  .controller 'AcademyModuleCtrl', AcademyModule


class DemoAcademyModule extends AcademyModule
  next: ->
    moduleId = @moduleId
    @$scope.allModules.forEach (module, index) =>
      if parseInt(module.id) == parseInt(moduleId)
        @nextModuleIndex = index + 1
    @$state.go 'demo.academy.module', moduleId: @$scope.allModules[@nextModuleIndex].id
    @Academy.finish({ module: moduleId }, {})

DemoAcademyModule.$inject = [ '$scope', 'DemoAcademy', '$stateParams', '$sce', '$log', '$state', '$location']

angular.module('switchfitApp')
  .controller 'DemoAcademyModuleCtrl', DemoAcademyModule
