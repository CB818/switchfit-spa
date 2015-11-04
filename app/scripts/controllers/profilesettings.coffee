'use strict'
angular.module('switchfitApp.settings', ['ui.router'])
.config ($stateProvider) ->
  $stateProvider
    .state 'settings',
      url: '/settings',
      templateUrl: 'views/profile-settings.html'
      controller: 'ProfileSettingsCtrl as profileSettings'
    .state 'demo.settings',
      url: '/settings',
      templateUrl: 'views/demo/settings.html'
      controller: 'ProfileSettingsCtrl as profileSettings'

class ProfileSettings
  constructor: (@$scope, @User, @$log, @FileUploader, API, @$rootScope, @$translate) ->
    @locales = [
      {
        locale: 'en',
        name: 'English'
      },
      {
        locale: 'de',
        name: 'Deutsch'
      }
    ]
    @editPersonal = false
    @editContact = false
    @password = ''
    @confirm = ''
    @$scope.user = {}
    @$rootScope.currentUser.$promise.then (user) =>
      dateOfBirth = new Date(user.dateOfBirth)
      @$scope.selectedDate = dateOfBirth.getDate()
      @$scope.selectedMonth = dateOfBirth.getMonth() + 1
      @$scope.selectedYear = dateOfBirth.getFullYear()
      @user = user
      @user.userId = user.id

      @$scope.uploader = new @FileUploader {
        url: API.path("users/#{@user.id}/picture")
        alias: 'picture'
        autoUpload: true,
        filters: [{
          name: 'File',
          fn: (item) ->
            if item.type in [ 'image/jpeg', 'image/png', 'image/jpg' ] and item.size <= 25*1024*1024
              true
            else
              alert "Please use jpg or png, file size <= 25Mb"
              false
        }]}
      scope = @$scope
      @$scope.uploader.onSuccessItem = (item, response, status, headers) ->
        scope.profileSettings.user.picture.c66x66 = response.picture.c66x66
        angular.element('.total-progress').css({width : '0%'})




      @$scope.uploader.onErrorItem = (item, response, status, headers) ->
        alert "Something is broken. Please try again later."

    @$scope.selectedDate = 1
    @dates = [ 1, 2, 3, 4, 5 ]
    @$scope.selectedMonth = 1
    @$scope.$watch 'selectedMonth', (month) =>
      @dates = [1 .. @months[month - 1].days]
    @months = [
      name: 'Jan'
      value: 1
      days: 31
    ,
      name: 'Feb'
      value: 2
      days: 28
    ,
      name: 'Mar'
      value: 3
      days: 31
    ,
      name: 'Apr'
      value: 4
      days: 30
    ,
      name: 'May'
      value: 5
      days: 31
    ,
      name: 'Jun'
      value: 6
      days: 30
    ,
      name: 'Jul'
      value: 7
      days: 31
    ,
      name: 'Aug'
      value: 8
      days: 31
    ,
      name: 'Sep'
      value: 9
      days: 30
    ,
      name: 'Oct'
      value: 10
      days: 31
    ,
      name: 'Nov'
      value: 11
      days: 30
    ,
      name: 'Dec'
      value: 12
      days: 31
    ]
    @$scope.selectedYear = 1999
    currentDate = new Date()
    currentYear = currentDate.getFullYear()
    @years = [ currentYear - 10 .. currentYear - 60 ]
    @$scope.openDropdown = ($event) ->
      angular.element($event.currentTarget).dropdown 'show';

    @$scope.getLocales = () =>
      return @locales

    @$scope.currentLocaleName = (locale) =>
      if locale isnt undefined
        currLoclale = @locales.filter (loc) =>
          loc.locale == locale
        if currLoclale.length != 0
          currLoclale = currLoclale[0]
        return currLoclale.name
      return 'Default'

  editPersonalInfo: (edit) =>
    @editPersonal = edit

  editContactInfo: (edit) =>
    @editContact = edit

  submitPersonal: =>
    dateOfBirth = new Date()
    dateOfBirth.setYear(@$scope.selectedYear)
    dateOfBirth.setMonth(@$scope.selectedMonth - 1)
    dateOfBirth.setDate(@$scope.selectedDate)

    @user.dateOfBirth = moment(dateOfBirth).format('DD.MM.YYYY')

    if @password != ''
      @user.plainPassword = @password

    @$scope.saveInProgress = true

    @user.$save (user) =>
      @$scope.saveInProgress = false
      @editPersonalInfo false
      @editContactInfo false
      @$rootScope.locale = user.locale
      @$rootScope.currentUser.picture = user.picture
      @$translate.use(user.locale)

ProfileSettings.$inject = [ '$scope', 'User', '$log', 'FileUploader', 'API', '$rootScope', '$translate' ]

angular.module('switchfitApp.settings')
  .controller 'ProfileSettingsCtrl', ProfileSettings