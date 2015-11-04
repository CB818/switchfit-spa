'use strict'

###*
 # @ngdoc service
 # @name switchfitApp.Academy
 # @description
 # # Academy
 # Service in the switchfitApp.
###
angular.module('switchfitApp')
  .service 'Academy', ($resource, API) ->
    Academy = $resource(API.path("academy/modules/:module"), { module: null }, {
      finish:
        method: 'PUT'
    })
    Academy.Topics = $resource(API.path("academy/modules/:module/topics/:topic"), { module: '@module', topic: '@id' }, {
      save:
        method: 'PUT'
      final:
        url: API.path("academy/modules/:module/topics/:topic/final")
        method: 'PUT'
    })
    Academy.Current = $resource(API.path("academy/module/current"), {}, {
      get:
        method: 'GET'
    })
    Academy
