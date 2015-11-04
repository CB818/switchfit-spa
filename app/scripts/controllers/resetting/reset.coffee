'use strict'

class ResettingReset
  constructor: (@$scope, @UserResetting, @$location, $stateParams) ->
    @success = false
    @token = null
    @new1 = null
    @new2 = null
    if $stateParams.token isnt undefined
      @token = $stateParams.token

    @errorMessage = null
    @$scope.isLoading = false
    if @token.length > 0
      @UserResetting.getRestCreds(@token).then (creds) =>
        @creds = creds
      , (resp) =>
        @$location.url('/app-login')

  reset: =>
    if @new1 != @new2
      @showError = true
      @errorMessage = 'Passwörter müssen übereinstimmen'
      return
    @$scope.isLoading = true
    if @token.length > 0
      @UserResetting.reset(@token, {
        new: {
          first: @new1
          second: @new2
        }
        _token: @creds.csrf_token
      }).then((data) =>
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

  goToDashboardWithRefresh: () =>
    window.location.href = '/'

ResettingReset.$inject = [ '$scope', 'UserResetting', '$location', '$stateParams' ]

angular.module('switchfitApp.resetting')
.controller 'ResettingResetCtrl', ResettingReset