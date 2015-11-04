'use strict'

angular.module('switchfitApp')
  .service 'Workouts', (API, $resource) ->
    Workouts = $resource API.path('workouts/:workoutId'), { workoutId: null }, {
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
      locations:
        url: API.path('workouts/locations')
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

      oftheday:
        url:API.path('workout/oftheday')
        method: 'GET',
        headers :
          "X-Requested-With": "XMLHttpRequest"
    }

    Workouts
