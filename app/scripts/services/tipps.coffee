'use strict'

###*
 # @ngdoc service
 # @name switchfitApp.life
 # @description
 # # Tipp
 # Service in the switchfitApp.
###
angular.module('switchfitApp')
.service 'TippsData', (API, $resource) ->
  TippsData = $resource API.path('tipps/'), {}, {
    get:
      method  : 'GET',
      isArray : true
  }
  TippsData

