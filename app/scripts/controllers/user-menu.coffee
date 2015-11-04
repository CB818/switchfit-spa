'use strict'

class UserMenu
  constructor: (@$scope, @$cookieStore, @Notifications, $rootScope, @Login, @$timeout) ->
    $scope.showPopover = true
    $scope.hasNotice = false
    $rootScope.$watch('userCourse.paymentUrl', (paymentUrl) =>
      $scope.paymentUrl = paymentUrl
    )
    #openClose
    $scope.openClose = =>
      $scope.showPopover = !$scope.showPopover
      if $scope.showPopover
        $rootScope.$broadcast('notification_popover.close');
    # logout
    $scope.logout = =>
#      domainParts = window.location.hostname.split(".")
#      lengthParts = domainParts.length
#      sessDomainRoot = '.' + domainParts[lengthParts-2] + '.' + domainParts[lengthParts-1]
#      sessDomainApp = 'app.' + domainParts[lengthParts-2] + '.' + domainParts[lengthParts-1]
#      document.cookie = 'switchfit_sessid=; path=/; domain=' + sessDomainRoot + '; expires=Thu, 01-Jan-70 00:00:01 GMT;'
#      document.cookie = 'switchfit_sessid=; path=/; domain=' + sessDomainApp + '; expires=Thu, 01-Jan-70 00:00:01 GMT;'
      @Login.logout({}).then(
          (data) =>
            @$cookieStore.remove('switchfit_sessid')            
            window.Intercom('shutdown')
            if data.data isnt undefined and data.data.redirectUrl isnt undefined
              window.location.href = data.data.redirectUrl
            else
              window.location.href = '/app-login'
        =>
          @showError = true
        )

UserMenu.$inject = [ '$scope', '$cookieStore', 'Notifications', '$rootScope', 'Login', '$timeout' ]

angular.module('switchfitApp')
  .controller 'UserMenuCtrl', UserMenu