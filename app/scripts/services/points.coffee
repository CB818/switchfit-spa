'use strict'

###*
 # @ngdoc service
 # @name switchfitApp.points
 # @description
 # # Points
 # Service in the switchfitApp.
###

angular.module('switchfitApp')
.service 'Points', (API, $resource) ->
  Points = $resource API.path('points'), {}, {
    get:
      method: 'GET'
  }
  Points

