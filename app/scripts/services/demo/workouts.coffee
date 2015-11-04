'use strict'

###*
 # @ngdoc service
 # @name switchfitApp.demo/workouts
 # @description
 # # demo/workouts
 # Service in the switchfitApp.
###
angular.module('switchfitApp')
  .service 'DemoWorkouts', (API, $resource) ->
    DemoWorkouts = $resource API.path('demo/workouts/:workoutId'), { workoutId: null }, {
      categories:
        url: API.path('workouts/categories')
        isArray: true
        headers:
          "X-Requested-With": "XMLHttpRequest"

      types:
        url: API.path('workouts/types')
        isArray: true
        headers:
          "X-Requested-With": "XMLHttpRequest"

      fav:
        url: API.path('workouts/:mealId/favorite')
        method: 'POST'
        headers:
          "X-Requested-With": "XMLHttpRequest"

      unfav:
        url: API.path('workouts/:mealId/favorite')
        method: 'DELETE'
        headers:
          "X-Requested-With": "XMLHttpRequest"
    }

    DemoWorkouts
