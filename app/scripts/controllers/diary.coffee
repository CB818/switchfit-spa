'use strict'
angular.module('switchfitApp.diary', ['ui.router', 'bootstrapLightbox'])
.config ($stateProvider) ->
  $stateProvider
    .state 'diary',
      url: '/diary',
      templateUrl: 'views/diary.html'
      controller: 'DiaryCtrl as diary'
    .state 'demo.diary',
      url: '/diary',
      templateUrl: 'views/demo/diary.html'
      controller: 'DiaryCtrl as diary'

class Diary
  constructor: (@$scope, @Diary, @User, @$rootScope, @FileUploader, @API, @$timeout, @$log, $sce, @$modal, @Lightbox) ->
    @$rootScope.currentUser.$promise.then =>
      @currentUser = @$rootScope.currentUser
      @init()

    @pictureSize = 5
    @pictureShown = 1
    @moment = moment().subtract('M', 2).date(1).hours(0).minutes(0).seconds(0).milliseconds(0)
    @lastMoment
    @months = {}
    @entriesLimitCnt = {
      left: 0
      right: 0
    }
    $scope.diary = {};
    @$scope.trustedHtml = (html) =>
      return $sce.trustAsHtml(html)

    @$scope.openCarousel = (index) =>
      scopeModal = @$rootScope.$new()
      scopeModal.activeSlide = index
      @$modal.open({
        templateUrl: 'views/modals/carouselModal.html'
        windowClass: 'diary-carousel carousel frameless modal-md'
        controller: 'ModalDiaryCarouselCtrl',
        scope: scopeModal
      })

    @$scope.openLightboxModal = (image) =>
      images = [image];

      images =
        one:
          url: image

      @Lightbox.openModal(images, 'one');


  init: =>
    console.log("Diary init")
    @currentDate = new Date()
    diary = @Diary.get { userId: @currentUser.id }
    diary.$promise.then (diary) =>
      @bg = diary.bgPicture != null && diary.bgPicture.c970x325 || 'temp-img/user-bg.jpg'
      for entry in diary.entries
        @Diary.addEntryToSide(entry)
        entryMoment = moment(entry.createdAt)
        if (entryMoment < @moment)
          @months[entryMoment.format('M')] = {
            'MMM': entryMoment.format('MMM')
            'MMMM': entryMoment.format('MMMM')
          }
      @months = @sortObjectByKeysReverse(@months)

    pictures = @Diary.Picture.get { userId: @currentUser.id }
    pictures.$promise.then (pictures) =>
      @Diary.pictures = pictures

    @$scope.uploader = new @FileUploader {
        url: @API.path("users/#{@currentUser.id}/diary"),
        autoUpload: true,
        alias: 'bgPicture',
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
      if response.bgPicture
        scope.diary.bg = response.bgPicture.c970x325
        angular.element('.total-progress').css({width : '0%'})

    @$scope.uploader.onErrorItem = (item, response, status, headers) ->
      alert "Something wrong."

  sortObjectByKeysReverse: (obj) ->
    keys = Object.keys(obj)
    keys = keys.reverse()
    rObj = []
    for key in keys
      rObj.push(obj[key])
    return rObj

  isSideWithFirstEntry: (side) =>
    return @getSideWithFirstEntry() == side

  getSideWithFirstEntry: () =>
    return @Diary.entries.sideWithFirstEntry

  getEntries: (side) =>
    return @Diary.getEntriesBySide(side)

  getPictures: ->
    return @Diary.pictures

  entriesLimit: (side) ->
    cnt = 0
    entries = @Diary.getEntriesBySide(side)

    for ent in entries
      if (moment(ent.createdAt) > @moment)
        cnt++

    @entriesLimitCnt[side] = cnt;
    return @entriesLimitCnt[side]

  hasEntriesForMonth: (month) ->
    cnt = 0
    @lastMoment = moment().month(month).date(1).hours(0).minutes(0).seconds(0).milliseconds(0)
    entries = @Diary.entries.left.concat(@Diary.entries.right)
    for ent in entries
      if (moment(ent.createdAt) > @lastMoment)
        cnt++
    return !(cnt <= @entriesLimitCnt['left'] + @entriesLimitCnt['right'])

  showEntriesForMonth: (month) ->
    cntl = 1
    cntr = 1
    @lastMoment = moment().month(month).date(1).hours(0).minutes(0).seconds(0).milliseconds(0)
    for entl in @Diary.entries.left
      if (moment(entl.createdAt) > @lastMoment)
        cntl++
    for entr in @Diary.entries.right
      if (moment(entr.createdAt) > @lastMoment)
        cntr++

    @moment = @lastMoment
    @entriesLimitCnt['left'] = cntl;
    @entriesLimitCnt['right'] = cntr;

  picturesLimit: ->
    return @pictureSize * @pictureShown

  hasMorePicturesToShow: ->
    return @pictureShown < (@Diary.pictures.length / @pictureSize)

  showMorePictures: ->
    @pictureShown = @pictureShown + 1

  bgClick: =>
    @$timeout(->
      angular.element('#diary-bg').click()
    )


Diary.$inject = [ '$scope', 'Diary', 'User', '$rootScope', 'FileUploader', 'API', '$timeout', '$log', '$sce', '$modal', 'Lightbox' ]

angular.module('switchfitApp.diary')
.controller 'DiaryCtrl', Diary
