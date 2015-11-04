'use strict'

angular.module('switchfitApp')
  .service 'Course', ($resource, API) ->
    # AngularJS will instantiate a singleton by calling "new" on this function
    Course = $resource(API.path("users/:userId/courses/:courseId"), {  }, { })
    Course.Weeks = $resource API.path("users/:userId/courses/:courseId/weeks"), {  }, {
      add:
        method: 'POST'
    }
    Course.Week = $resource API.path("users/:userId/courses/:courseId/weeks/:number"), {  }, {
      get:
        method: 'GET'
      update:
        method: 'PUT'
    }
    Course.Signature = $resource API.path("users/:userId/courses/:courseId/signature"), {  }, {
      sig:
        method: 'PATCH'
    }
    Course.Warmup = $resource API.path("users/:userId/courses/:courseId/warmup"), {  }, {
      update:
        method: 'PUT'
    }
    Course.Inspire = $resource API.path("users/:userId/courses/:courseId/inspire"), {  }, {
      me:
        method: 'GET'
    }
    Course.Ping = $resource API.path("users/ping"), {  }, {
      me:
        method: 'GET',
    }
    Course
