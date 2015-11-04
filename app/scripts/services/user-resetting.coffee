'use strict'

###*
 # @ngdoc service
 # @name switchfitApp.userResetting
 # @description
 # # userResetting
 # Service in the switchfitApp.
###
angular.module('switchfitApp')
.service 'UserResetting', ($http) ->
  UserResetting =
    request: ->
      $http.get('/resetting/request', headers: { 'X-Requested-With': 'XMLHttpRequest' }).then (resp) -> resp.data

    sendEmail: (creds) ->
      $http.post('/resetting/send-email', creds, headers: { 'X-Requested-With': 'XMLHttpRequest' })

    reset: (token, creds) ->
      $http.post('/resetting/reset/'+ token, creds, headers: { 'X-Requested-With': 'XMLHttpRequest' })

    getRestCreds: (token) ->
      $http.get('/resetting/reset/'+ token, headers: { 'X-Requested-With': 'XMLHttpRequest' }).then (resp) -> resp.data

  UserResetting
