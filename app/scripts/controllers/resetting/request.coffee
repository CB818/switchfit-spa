'use strict'

angular.module('switchfitApp.resetting', ['ui.router'])
.config ($stateProvider) ->
  $stateProvider
    .state 'resetting',
      url: '/app-resetting',
      templateUrl: 'views/resetting/request.html'
      controller: 'ResettingRequestCtrl as request'
    .state 'resetting.reset',
      url: '/:token',
      templateUrl: 'views/resetting/reset.html'
      controller: 'ResettingResetCtrl as reset'

class ResettingRequest
  constructor: (@$scope, @UserResetting, @$location) ->
    @success = false
    @username = null
    @errorMessage = null
    @$scope.isLoading = false
#    UserResetting.request().then (creds) =>
#      @creds = creds

  sendEmail: =>
    @$scope.isLoading = true
    @UserResetting.sendEmail({
      username: @username
    }).then(
      (data) =>
        @success = true
        @$scope.isLoading = false
        @successMsg = data.data.msg
      ,
      (data) =>
        @showError = true
        @$scope.isLoading = false
        if data.data.msg isnt undefined
          @errorMessage = data.data.msg
    )

ResettingRequest.$inject = [ '$scope', 'UserResetting', '$location' ]

angular.module('switchfitApp.resetting')
  .controller 'ResettingRequestCtrl', ResettingRequest
