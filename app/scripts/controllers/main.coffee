'use strict'

angular.module('switchfitApp')
.controller 'MainCtrl', ($scope, $rootScope, $location, $log) ->
    $scope.selectedMood = '1'
    $scope.selectMood = ''
    $scope.oneAtATime = true;
    $scope.status = {
      isFirstOpen: true
      isFirstDisabled: false
    }

    $scope.panels = [
      heading: "Introduction to module eight."
      content: "This content is straight in the template."
    ,
      heading: "Insuline resistance and lorem ipsum longer title."
      content: "This content is straight in the template."
    ]

    # Set of Photos
    $scope.photos = [
      {src: 'http://farm9.staticflickr.com/8042/7918423710_e6dd168d7c_b.jpg', desc: 'Image 01'}
      {src: 'http://farm9.staticflickr.com/8449/7918424278_4835c85e7a_b.jpg', desc: 'Image 02', video: true}
      {src: 'http://farm9.staticflickr.com/8457/7918424412_bb641455c7_b.jpg', desc: 'Image 03'}
      {src: 'http://farm9.staticflickr.com/8179/7918424842_c79f7e345c_b.jpg', desc: 'Image 04'}
      {src: 'http://farm9.staticflickr.com/8315/7918425138_b739f0df53_b.jpg', desc: 'Image 05', video: true}
      {src: 'http://farm9.staticflickr.com/8461/7918425364_fe6753aa75_b.jpg', desc: 'Image 06'}
      {src: 'http://farm9.staticflickr.com/8461/7918425364_fe6753aa75_b.jpg', desc: 'Image 06'}
      {src: 'http://farm9.staticflickr.com/8315/7918425138_b739f0df53_b.jpg', desc: 'Image 05'}
      {src: 'http://farm9.staticflickr.com/8179/7918424842_c79f7e345c_b.jpg', desc: 'Image 04', video: true}
      {src: 'http://farm9.staticflickr.com/8457/7918424412_bb641455c7_b.jpg', desc: 'Image 03'}
      {src: 'http://farm9.staticflickr.com/8449/7918424278_4835c85e7a_b.jpg', desc: 'Image 02'}
      {src: 'http://farm9.staticflickr.com/8042/7918423710_e6dd168d7c_b.jpg', desc: 'Image 01'}
    ]

    # initial image index
    $scope._Index = 0

    # if a current image is the same as requested image
    $scope.isActive = (index) ->
      $scope._Index == index

    # show prev image
    $scope.showPrev = ->
      $scope._Index = (if ($scope._Index > 0) then --$scope._Index else $scope.photos.length - 1)

    # show next image
    $scope.showNext = ->
      $scope._Index = ((if $scope._Index < $scope.photos.length - 1 then ++$scope._Index else 0))

    # show a certain image
    $scope.showPhoto = (index) ->
      $scope._Index = index

    $scope.myPhotos = [
      {src: 'temp-img/photo-1.jpg', date: 'December 15'}
      {src: 'temp-img/photo-2.jpg', date: 'December 15'}
      {src: 'temp-img/photo-1.jpg', date: 'December 15'}
      {src: 'temp-img/photo-2.jpg', date: 'December 15'}
      {src: 'temp-img/photo-1.jpg', date: 'December 15'}
      {src: 'temp-img/photo-2.jpg', date: 'December 15'}
      {src: 'temp-img/photo-1.jpg', date: 'December 15'}
      {src: 'temp-img/photo-2.jpg', date: 'December 15'}
      {src: 'temp-img/photo-1.jpg', date: 'December 15'}
      {src: 'temp-img/photo-2.jpg', date: 'December 15'}
    ]