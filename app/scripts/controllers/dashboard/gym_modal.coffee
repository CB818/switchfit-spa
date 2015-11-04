'use strict'

###*
 # @ngdoc function
 # @name switchfitApp.controller:ModalGymModalCtrl
 # @description
 # # ModalGymModalCtrl
 # Controller of the switchfitApp
###

class WorkoutsModal
  constructor: (@$scope, @$log, @Workouts, @$rootScope, @usSpinnerService, @$timeout, @$filter, @$cookieStore) ->
    @onlyFavs = false
    @showMore = false
    @$scope.isLoading = true
    @defaultFiltersWorkout = {
      type: 0
      category: 0
      location: 0
      favs: false
    }
    @filtersWorkout = @$cookieStore.get('switchfit_filters_workout')
    if @filtersWorkout
      @filtersWorkout = _.assign(angular.copy(@defaultFiltersWorkout), @filtersWorkout)
    else
      @filtersWorkout = angular.copy(@defaultFiltersWorkout)
    @onlyFavs = @filtersWorkout.favs

    if !@isPromise(@Workouts.allTypes)
      @Workouts.allTypes = @Workouts.types()
    @Workouts.allTypes.$promise.then (types) =>
      @types = [ { id: 0, title: 'Alle Typen' } ].concat(types)
      @type = @filtersWorkout.type
      if !@isPromise(@Workouts.allCategories)
        @Workouts.allCategories = @Workouts.categories()
      @Workouts.allCategories.$promise.then (categories) =>
        @categories = [ { id: 0, title: 'Alle Kategorien' } ].concat(categories)
        @category = @filtersWorkout.category
        if !@isPromise(@Workouts.allLocations)
          @Workouts.allLocations = @Workouts.locations()
        @Workouts.allLocations.$promise.then (locations) =>
          @locations = [ { id: 0, title: 'Alle Standorte' } ].concat(locations)
          @location = @filtersWorkout.location


    if !@isPromise(@Workouts.allWorkouts)
      @Workouts.allWorkouts = @Workouts.query()
    @Workouts.allWorkouts.$promise.then (workouts) =>
      @allWorkouts = workouts
      @items = @allWorkouts
      @$scope.isLoading = false
      @$timeout () =>
        @$scope.isLoading = false
        @usSpinnerService.stop('gym-loader')
      , 200

  filteredWorkouts: =>
    if @allWorkouts?
      orderBy = @$filter('orderBy')
      @items = orderBy @allWorkouts, '-id'

      if @type != 0
        @items = @items.filter (workout) =>
          inTypes = workout.type.filter (type) =>
            type.id == @type
          if inTypes.length > 0
            true
          else
            false

      if @category != 0
        @items = @items.filter (workout) =>
          inCategories = workout.category.filter (category) =>
            category.id == @category
          if inCategories.length > 0
            true
          else
            false

      if @location != 0
        @items = @items.filter (workout) =>
          inLocations = workout.location.filter (location) =>
            location.id == @location
          if inLocations.length > 0
            true
          else
            false

      if @onlyFavs
        @items = @items.filter (workout) -> workout.favorite == true

      @currentFilteredWorkoutsLength = @items.length
      @items

  selectWorkout: (workout) =>
    @$rootScope.$broadcast('workout_modal.select', { day: @$scope.day, workout: workout, index: @$scope.timetableItemIndex})
    @$scope.$close()

  changeType: =>
    @filtersWorkout.type = @type
    @$cookieStore.put('switchfit_filters_workout', @filtersWorkout)

  changeCategory: =>
    @filtersWorkout.category = @category
    @$cookieStore.put('switchfit_filters_workout', @filtersWorkout)

  changeLocation: =>
    @filtersWorkout.location = @location
    @$cookieStore.put('switchfit_filters_workout', @filtersWorkout)

  changeFavs: (state) =>
    @onlyFavs = state
    @filtersWorkout.favs = @onlyFavs
    @$cookieStore.put('switchfit_filters_workout', @filtersWorkout)

  resetFilters: =>
    # selects fix
    @$timeout () =>
      angular.element('.bootstrap-select.type-select .selectpicker [rel="0"] a[tabindex="0"]').click()
      angular.element('.bootstrap-select.category-select .selectpicker [rel="0"] a[tabindex="0"]').click()
      angular.element('.bootstrap-select.location-select .selectpicker [rel="0"] a[tabindex="0"]').click()
      @type = 0
      @category = 0
      @location = 0

    # fav reset
    @onlyFavs = false
    @$cookieStore.put('switchfit_filters_workout', @defaultFiltersWorkout)

  isPromise: (obj) ->
    if angular.isObject(obj) &&
      angular.isObject(obj.$promise) &&
      obj.$promise.then instanceof Function &&
      obj.$promise["catch"] instanceof Function &&
      obj.$promise["finally"] instanceof Function
        return true
    return false

WorkoutsModal.$inject = [ '$scope', '$log', 'Workouts', '$rootScope', 'usSpinnerService', '$timeout', '$filter', '$cookieStore' ]

angular.module('switchfitApp.dashboard')
  .controller 'WorkoutsModalCtrl', WorkoutsModal
