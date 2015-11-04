'use strict'

class ModalDiaryCarousel
  constructor: (@$scope, @Diary, $timeout) ->
    @$scope.initSlide = true
    @$scope.slides = angular.copy(@Diary.pictures)
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

ModalDiaryCarousel.$inject = [ '$scope', 'Diary', '$timeout' ]

angular.module('switchfitApp.diary')
.controller 'ModalDiaryCarouselCtrl', ModalDiaryCarousel
