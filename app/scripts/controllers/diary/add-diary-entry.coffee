'use strict'

class ModalAddDiaryEntry
  constructor: (@$scope, @Diary, @User, @$rootScope, @$timeout, @$filter, @FileUploader, @API) ->
    @sides = ['left', 'right']
    @$scope.diarySref = 'diary'
    @$scope.diarySref = 'demo.diary' if $rootScope.isDemo


    @initDefaults();

    @$rootScope.currentUser.$promise.then =>
      @currentUser = @$rootScope.currentUser
      @init()

  initDefaults: =>
    @defaultText = ''
    @$scope.entry = {
      text: @defaultText
      emoji: ''
      photo: ''
    }

    @$scope.isDiaryPage = (@$rootScope.moduleName == 'diary')
    if @$scope.isDiaryPage
      @$scope.entry.sfLife = "0"
    else
      @$scope.entry.sfLife = "1"

    @$scope.uploadedImage = null

  init: =>
    @$scope.submit = (diaryForm) =>
      @addEntry()
      return false

    @$scope.errors = []
    @$scope.errorsFields = {}
    @$scope.isLoading = false

    @$scope.hasUploadFile = () =>
      return @$scope.entry.photo instanceof File

    @$scope.getUploadFileName = () =>
      if @$scope.entry.photo instanceof File
        return @$scope.entry.photo.name

    @$scope.getUploadFileSize = () =>
      if @$scope.entry.photo instanceof File
        return Math.round(@$scope.entry.photo.size / 1024) + 'Kb'

    @$scope.entryPhotoClick = () =>
      @$timeout(->
        $('#entry-photo').click()
      )

    @$scope.entryRemovePreviewPhotoClick = () =>
      @$scope.uploadedImage = null

    @$scope.textLength = 5000
    @$scope.checkTextLength = () =>
      if @$scope.entry.text.length > @$scope.textLength
        @$scope.entry.text = @$filter('limitTo')(@$scope.entry.text, @$scope.textLength)

    @$scope.uploader = new @FileUploader {
      url: @API.path("users/#{@currentUser.id}/diary/entries/picture"),
      autoUpload: true,
      alias: 'picture',
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
      scope.uploadedImage = response;
      angular.element('.total-progress').css({width : '0%'})
      scope.isLoading = false

    @$scope.uploader.onAfterAddingFile = (fileItem) ->
      scope.isLoading = true

    @$scope.uploader.onErrorItem = (item, response, status, headers) ->
      scope.isLoading = false
      alert "Das Bild konnte leider nicht hochgeladen werden."

  addEntry: () =>
    @$scope.isLoading = true
    if @$scope.entry.text == @defaultText
      @$scope.entry.text = ''
  
    fd = new FormData()
    fd.append('text', @$scope.entry.text)
    fd.append('emoji', @$scope.entry.emoji)
    fd.append('public', @$scope.entry.sfLife)
    if @$scope.uploadedImage
      fd.append('id', @$scope.uploadedImage.id)

    @$scope.errors = []
    @Diary.Entry.add {userId: @currentUser.id}, fd, (data) =>
      data.user = @currentUser
      ### Update User Points Count ###
      @$rootScope.globalPoints.$emit('updatePoints')

      if data.id != undefined
        if data.public
          if !(data.picture is null)
            window.Intercom('trackEvent', 'create-life-entry-picture')
          else
            window.Intercom('trackEvent', 'create-life-entry')
        else
          if !(data.picture is null)
            window.Intercom('trackEvent', 'create-diary-entry-picture')
          else
            window.Intercom('trackEvent', 'create-diary-entry')

      # on diary page we need to post the post on left or right side
      if data.id != undefined && @$rootScope.moduleName == 'diary'
        @Diary.addEntryToSide(data, true)
        if data.picture
          @Diary.pictures.unshift(data)
      # post on switchfit life feed if post was public
      else if data.id != undefined && @$scope.entry.sfLife == "1"
        @$scope.entries.push(data)

      @$scope.isLoading = false
      $('form').get(0).reset()
      @initDefaults();

    , (data) =>
      if data.data && data.data.errors && data.data.errors.children
        for field, error of data.data.errors.children
          if error.errors
            for err in error.errors
              @$scope.errors.push(err)
              @$scope.errors[field] = true

      if @$scope.errors.length == 0
        @$scope.errors.push('Something wrong!')

      @$scope.isLoading = false

ModalAddDiaryEntry.$inject = [ '$scope', 'Diary', 'User', '$rootScope', '$timeout', '$filter', 'FileUploader', 'API']

angular.module('switchfitApp.diary')
  .controller 'ModalAddDiaryEntryCtrl', ModalAddDiaryEntry
