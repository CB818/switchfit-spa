'use strict'

angular.module('switchfitApp')
  .service 'Day', ($resource, API) ->
    Day = $resource API.path("users/:userId/courses/:courseId/days"), {  }, {
      add:
        method: 'POST'
    }
    Day
