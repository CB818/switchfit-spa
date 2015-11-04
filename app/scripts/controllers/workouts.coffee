'use strict'
angular.module('switchfitApp.gym', ['ui.router'])
.config ($stateProvider) ->
  $stateProvider
    .state 'gym',
      url: '/gym',
      templateUrl: 'views/gym.html'
      controller: 'WorkoutsCtrl as workouts'
    .state 'gym.hiits-lows-burns',
      url: '/hiits-lows-burns',
      templateUrl: 'views/gym/hiits-lows-burns.html'
      controller: 'ContentPageCtrl'
    .state 'gym.weekly-challenges',
      url: '/weekly-challenges',
      templateUrl: 'views/gym/weekly-challenges.html'
      controller: 'ContentPageCtrl'
    .state 'gym.fitness-mark',
      url: '/fitness-mark',
      templateUrl: 'views/gym/fitness-mark.html'
      controller: 'ContentPageCtrl'
    .state 'gym.tools',
      url: '/tools',
      templateUrl: 'views/gym/tools.html'
      controller: 'ContentPageCtrl'
    .state 'gym.experts',
      url: '/experts',
      templateUrl: 'views/gym/experts.html'
      controller: 'ContentPageCtrl'
    .state 'gym.workout',
      url: '/:workout',
      templateUrl: 'views/gym/workout.html'
      controller: 'WorkoutsItemCtrl as workout'
    .state 'demo.gym',
      url: '/gym',
      templateUrl: 'views/demo/gym.html'
      controller: 'DemoWorkoutsCtrl as workouts'
    .state 'demo.gym.workout',
      url: '/:workout',
      templateUrl: 'views/demo/workout.html'
      controller: 'DemoWorkoutsItemCtrl as workout'

class Workouts
  constructor: (@$scope, @$log, @Workouts, @usSpinnerService, @$filter, @$timeout, @$cookieStore) ->
    @showMore = false
    @workoutsShown = 1
    @workoutsSize = 25
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
      @$scope.allWorkouts = workouts
      @$scope.isLoading = false
      @usSpinnerService.stop('gym-loader')

    window.Intercom('trackEvent', 'page-visit-gym')

  filteredWorkouts: =>
    if @$scope.allWorkouts?
      orderBy = @$filter('orderBy')
      workouts = orderBy @$scope.allWorkouts, '-id'

      if @type != 0
        workouts = workouts.filter (workout) =>
          inTypes = workout.type.filter (type) =>
            type.id == @type
          if inTypes.length > 0
            true
          else
            false

      if @category != 0
        workouts = workouts.filter (workout) =>
          inCategories = workout.category.filter (category) =>
            category.id == @category
          if inCategories.length > 0
            true
          else
            false

      if @location != 0
        workouts = workouts.filter (workout) =>
          inLocations = workout.location.filter (location) =>
            location.id == @location
          if inLocations.length > 0
            true
          else
            false

      if @onlyFavs
        workouts = workouts.filter (workout) -> workout.favorite == true

      @currentFilteredWorkoutsLength = workouts.length
      workouts

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
    @onlyFavs = false

    # type select fix
    @$timeout () =>
      angular.element('.bootstrap-select.type-select .selectpicker [rel="0"] a[tabindex="0"]').click()
      @type = 0

    # category select fix
    @$timeout () =>
      angular.element('.bootstrap-select.category-select .selectpicker [rel="0"] a[tabindex="0"]').click()
      @category = 0

    # location select fix
    @$timeout () =>
      angular.element('.bootstrap-select.location-select .selectpicker [rel="0"] a[tabindex="0"]').click()
      @location = 0

    @$cookieStore.put('switchfit_filters_workout', @defaultFiltersWorkout)

  getPreview: (workout) =>
    for media in workout.media
#      if media.type == 'photo'
      return media

  showingWorkoutsLength: =>
    if @currentFilteredWorkoutsLength > @workoutsSize * @workoutsShown
      return @workoutsSize * @workoutsShown
    else
      return @currentFilteredWorkoutsLength

  workoutsLimit: ->
    return @workoutsSize * @workoutsShown

  hasMoreWorkoutsToShow: ->
    filteredWorkouts = @filteredWorkouts()
    if filteredWorkouts is undefined
      return false

    return @workoutsShown < (@filteredWorkouts().length / @workoutsSize)

  showMoreWorkouts: ->
    @workoutsShown = @workoutsShown + 1

  isPromise: (obj) ->
    if angular.isObject(obj) &&
      angular.isObject(obj.$promise) &&
      obj.$promise.then instanceof Function &&
      obj.$promise["catch"] instanceof Function &&
      obj.$promise["finally"] instanceof Function
        return true
    return false

Workouts.$inject = [ '$scope', '$log', 'Workouts', 'usSpinnerService', '$filter', '$timeout', '$cookieStore' ]

angular.module('switchfitApp.gym')
.controller 'WorkoutsCtrl', Workouts


class DemoWorkouts extends Workouts

DemoWorkouts.$inject = [ '$scope', '$log', 'DemoWorkouts', 'usSpinnerService', '$filter', '$timeout', '$cookieStore' ]

angular.module('switchfitApp.gym')
.controller 'DemoWorkoutsCtrl', DemoWorkouts

class WorkoutOfTheDay
  constructor:(@$scope, @$Workouts) ->
    ### Workout of the Day ###
    @$WoD = @$Workouts.oftheday()
    @$WoD.$promise.then (result) =>
      @$scope.wod = result
    , (err) =>
      console.log(err)

WorkoutOfTheDay.$inject = [ '$scope', 'Workouts'];
angular.module('switchfitApp.gym').controller 'WorkoutOfTheDayCtrl', WorkoutOfTheDay
