'use strict'

angular.module('switchfitApp')
  .controller 'ModalCtrl', ($scope, $log) ->
    $log.warning "ModalCtrl deprecated. Please use your own controller"
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
    $scope.selectedMeal = 'a'
    $scope.selectedWorkout = 'hiit'
    $scope.filterByLocation = 'showall'

    $scope.slides = [
      {src: 'temp-img/carousel-1.jpg', title: 'Lorem ipsum sit dolore amet'}
      {src: 'temp-img/carousel-2.jpg', title: 'Lorem ipsum sit dolore amet 2'}
      {src: 'temp-img/carousel-1.jpg', title: 'Lorem ipsum sit dolore amet 3'}
    ]

    $scope.days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
    $scope.detoxDays = ['Tuesday', 'Wednesday', 'Thursday', 'Friday']