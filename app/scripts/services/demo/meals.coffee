'use strict'

###*
 # @ngdoc service
 # @name switchfitApp.DemoMeals
 # @description
 # # DemoMeals
 # Service in the switchfitApp.
###
angular.module('switchfitApp')
  .service 'DemoMeals', (API, $resource) ->
    DemoMeals = $resource API.path('demo/meals/:mealId'), { mealId: null }, {
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

    DemoMeals
