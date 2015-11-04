'use strict'
angular.module('switchfitApp.community', ['ui.router', 'bootstrapLightbox'])
.config ($stateProvider) ->
  $stateProvider
    .state 'community',
      url: '/',
      views : {
        "" : {
          controller: 'CommunityCtrl',
          templateUrl: 'views/community.html'
        },
        "feed@community" : {
          controller: 'CommunityLifeFeedV1Ctrl'
        }
      },
    .state 'community-entry',
      url: '/entry/{entryId:[0-9]{1,5}}',
      views : {
        "" : {
          controller: 'CommunityCtrl',
          templateUrl: 'views/community.html'
        },
        "feed@community-entry" : {
          controller: 'CommunityLifeFeedV1Ctrl'
        }
      },
    .state 'community.blog',
      url: '/blog',
      templateUrl: 'views/community/blog.html'
      controller: 'BlogFeedCtrl'
    .state 'community.top-posts',
      url: '/top-posts',
      templateUrl: 'views/community/top-posts.html'
      controller: 'TopPostsCtrl'
    .state 'demo.community',
      url: '/community',
      templateUrl: 'views/demo/community.html'
      controller: 'MainCtrl'


class Community
  constructor: (@$scope, @$log, @Life, @$rootScope, @$modal, @Lightbox, @$timeout) ->
    @$rootScope.currentUser.$promise.then =>
      @course = @$rootScope.userCourse.course
      @Life.Header.get { courseId: @course.id }, (header) =>
        @$scope.header = header
      , () =>
        @$scope.header = {
          bgPicture: 'temp-img/user-bg.jpg'
          author: 'SwitchFit'
        }

      @$timeout( () =>
        globalPoints = @$rootScope.globalPoints
        globalPoints.$on 'updatePoints', () =>
          @$scope.updateCities()
          undefined
      , 500 )



      @$scope.updateCities = () =>
        @Life.Cities.get { courseId: @course.id }, (cities) =>
          @$scope.cities = cities
          @$rootScope.cities = cities
      @$scope.updateCities()

    @Life.Video.get {}, (videos) =>
      @videos = videos
      if videos.length == 1
        @$scope.video = videos[0]
      else if videos.length > 0
        @$scope.video = videos[Math.floor(Math.random()*videos.length)]

    @$scope.openVideoModal = (video) =>
        scopeModal = @$rootScope.$new()
        scopeModal.video = video
        @$modal.open({
          templateUrl: 'views/modals/sfLifeVideoModal.html'
          windowClass: 'frameless modal-md fade in'
          controller: 'ModalLifeVideoCtrl',
          scope: scopeModal
        })

    @$scope.openCitiesModal = () =>
        scopeCities = @$rootScope.$new()
        scopeCities.cities = @$rootScope.cities
        @$modal.open({
          templateUrl: 'views/modals/cities.html'
          windowClass: 'modal'
          controller: 'ModalCitiesCtrl',
          scope: scopeCities
        })

    @$scope.openLightboxModal = (image) =>
        images = [image];

        images =
          one:
            url: image

        @Lightbox.openModal(images, 'one');


Community.$inject = [ '$scope', '$log', 'Life', '$rootScope', '$modal', 'Lightbox', '$timeout' ]

angular.module('switchfitApp.community')
.controller 'CommunityCtrl', Community