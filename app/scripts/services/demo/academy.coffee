'use strict'

###*
 # @ngdoc service
 # @name switchfitApp.DemoAcademy
 # @description
 # # DemoAcademy
 # Service in the switchfitApp.
###
angular.module('switchfitApp')
  .service 'DemoAcademy', ($resource, API) ->
    DemoAcademy = $resource(API.path("demo/academy/modules/:module"), { module: null }, {
      finish:
        method: 'PUT'
    })
    DemoAcademy.Topics = $resource(API.path("academy/modules/:module/topics/:topic"), { module: '@module', topic: '@id' }, {
      save:
        method: 'PUT'
      final:
        url: API.path("academy/modules/:module/topics/:topic/final")
        method: 'PUT'
    })
    DemoAcademy
