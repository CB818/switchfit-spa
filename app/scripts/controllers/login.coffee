'use strict'

angular.module('switchfitApp.login', ['ui.router'])
.config ($stateProvider) ->
  $stateProvider
  .state 'login',
    url: '/app-login',
    templateUrl: 'views/login.html'
    controller: 'LoginCtrl as login'

class Login
  constructor: (@Login, @$log, @$location, @$rootScope) ->
    @Login.login().then (creds) =>
      @creds = creds
      if @$rootScope.userLoaded
        @$location.url('/')

  loginCheck: =>
    @Login.loginCheck({
      _username: @username
      _password: @password
      _csrf_token: @creds.csrf_token
    }).then(
      =>
        @$location.url('/')
      ,
      =>
        @showError = true
    )

Login.$inject = [ 'Login', '$log', '$location', '$rootScope' ]

angular.module('switchfitApp.login')
  .controller 'LoginCtrl', Login
