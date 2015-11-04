'use strict'

angular.module('switchfitApp')
  .service 'Meals', (API, $resource) ->
    Meals = $resource API.path('meals/:mealId'), { mealId: null }, {
      categories:
        url: API.path('meals/categories')
        isArray: true
        headers:
          "X-Requested-With": "XMLHttpRequest"

      types:
        url: API.path('meals/types')
        isArray: true
        headers:
          "X-Requested-With": "XMLHttpRequest"

      filters:
        url: API.path('meals/filters')
        headers:
          "X-Requested-With": "XMLHttpRequest"

      fav:
        url: API.path('meals/:mealId/favorite')
        method: 'POST'
        headers:
          "X-Requested-With": "XMLHttpRequest"

      unfav:
        url: API.path('meals/:mealId/favorite')
        method: 'DELETE'
        headers:
          "X-Requested-With": "XMLHttpRequest"
    }

    Meals
