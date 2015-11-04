'use strict'

###*
 # @ngdoc function
 # @name switchfitApp.controller:WorkoutsItemCtrl
 # @description
 # # WorkoutsItemCtrl
 # Controller of the switchfitApp
###
class WorkoutsItem
  constructor: ($scope, $stateParams, @Workouts, $filter, @$state) ->
    newLinesFilter = $filter('newLines')
    @parentScope = $scope.$parent
    workoutItemId = $stateParams.workout
    @Workouts.get({ workoutId: workoutItemId }).$promise.then (workout) =>
      @info = workout
      @info.instructions = newLinesFilter @info.instructions
      @info.additionalInfo = newLinesFilter @info.additionalInfo
      @info.tips = newLinesFilter @info.tips
      $scope.workoutPhotos = @info.media
      if workout.wod == true
        window.Intercom('trackEvent', 'PAGE-VISIT-WOD')

    @isLoading = false
    # initial image index
    $scope._Index = 0

    # if a current image is the same as requested image
    $scope.isActive = (index) ->
      $scope._Index == index

    # show prev image
    $scope.showPrev = ->
      $scope._Index = (if ($scope._Index > 0) then --$scope._Index else $scope.workoutPhotos.length - 1)

    # show next image
    $scope.showNext = ->
      $scope._Index = ((if $scope._Index < $scope.workoutPhotos.length - 1 then ++$scope._Index else 0))

    # show a certain image
    $scope.showPhoto = (index) ->
      $scope._Index = index

  fav: =>
    id = @info.id
    @isLoading = true
    if @info.favorite
      @Workouts.unfav { mealId: id }, {}, (data) =>
        @info.favorite = false
        @isLoading = false
        # update list
        @parentScope.allWorkouts.filter (workout) ->
          if workout.id == id
            workout.favorite = false
    else
      @Workouts.fav { mealId: id }, {}, (data) =>
        @info.favorite = true
        @isLoading = false
        # update list
        @parentScope.allWorkouts.filter (workout) ->
          if workout.id == id
            workout.favorite = true

    @info.favorite = !@info.favorite

WorkoutsItem.$inject = [ '$scope', '$stateParams', 'Workouts', '$filter', '$state' ]

angular.module('switchfitApp')
  .controller 'WorkoutsItemCtrl', WorkoutsItem


class DemoWorkoutsItem extends WorkoutsItem

DemoWorkoutsItem.$inject = [ '$scope', '$stateParams', 'DemoWorkouts', '$filter' ]

angular.module('switchfitApp')
  .controller 'DemoWorkoutsItemCtrl', DemoWorkoutsItem
