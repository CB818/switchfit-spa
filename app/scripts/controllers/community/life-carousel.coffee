'use strict'

class ModalLifeCarousel
  constructor: (@$scope, @Life, $timeout, $filter) ->
    slides = angular.copy(@Life.entries)
    @$scope.initSlide = true
    @$scope.slides = $filter('orderBy')(slides, '-createdAt')
    if @$scope.activeSlide > 0
      $timeout () =>
        @$scope.slides[@$scope.activeSlide].active = true
      , 100
    else
      $timeout () =>
        @$scope.slides[0].active = true
      , 100

    $timeout () =>
      @$scope.initSlide = false
    , 1200

ModalLifeCarousel.$inject = [ '$scope', 'Life', '$timeout', '$filter' ]

angular.module('switchfitApp.community')
.controller 'ModalLifeCarouselCtrl', ModalLifeCarousel
