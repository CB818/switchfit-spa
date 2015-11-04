'use strict'

angular.module('switchfitApp')
  .service 'User', ($resource, API, $log) ->
    User = $resource(API.path("users/:userId"), { userId: '@id' }, {
      get:
        headers:
          "X-Requested-With": "XMLHttpRequest"
      save:
        method: 'PUT'
    })
    User.Weight = $resource(API.path("users/:userId/courses/:courseId"), {},
      {
        post:
          method: "POST"
      }
    )
    User.Measurements = $resource(API.path("users/:userId/courses/:courseId"), {},
      {
        post:
          method: "POST"
      }
    )
    User.Vegetarian = $resource(API.path("users/:userId/courses/:courseId"), {},
      {
        post:
          method: "POST"
      }
    )
    ###
    User =
      get: (userId = 'current') ->
        $http.get(API.path("users/#{userId}"),
          headers:
            "X-Requested-With": "XMLHttpRequest"
        )
    ###
    User