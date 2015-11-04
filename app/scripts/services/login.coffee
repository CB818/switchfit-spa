'use strict'

angular.module('switchfitApp')
  .service 'Login', ($http) ->
    Login =
      login: ->
        $http.get('/login', headers: { 'X-Requested-With': 'XMLHttpRequest' }).then (resp) -> resp.data

      loginCheck: (creds) ->
        $http.post('/login_check', creds, headers: { 'X-Requested-With': 'XMLHttpRequest' })

      logout: ->
        $http.get('/logout', headers: { 'X-Requested-With': 'XMLHttpRequest' })

    Login