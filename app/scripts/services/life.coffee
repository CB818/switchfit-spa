'use strict'

###*
 # @ngdoc service
 # @name switchfitApp.life
 # @description
 # # life
 # Service in the switchfitApp.
###

angular.module('switchfitApp')
  .service 'Life', (API, $resource) ->

    Life = $resource API.path('life/entries'), {}, {
      get:
        method: 'GET',
        isArray: true
    }
    Life.Entry = $resource API.path('life/entries/:entryId'), {}, {
      get:
        method: 'GET'
    }
    Life.Header = $resource API.path('life/headers/:courseId'), {}, {
      get:
        method: 'GET'
    }
    Life.Video = $resource API.path('life/video'), {}, {
      get:
        method: 'GET'
        isArray: true
    }
    Life.Like = $resource API.path('life/entries/:entryId/likes'), {}, {
      post:
        method: 'POST'
    }
    Life.Unlike = $resource API.path('life/entries/:entryId/unlikes'), {}, {
      post:
        method: 'POST'
    }
    Life.Comment = $resource API.path('life/entries/:entryId/comments'), {}, {
      post:
        method: 'POST'
    }
    Life.LikeComment = $resource API.path('life/comments/:commentId/likes'), {}, {
      post:
        method: 'POST'
    }
    Life.UnlikeComment = $resource API.path('life/comments/:commentId/unlikes'), {}, {
      post:
        method: 'POST'
    }
    Life.SubComment = $resource API.path('life/entries/:entryId/comments/'), {}, {
      post:
        method: 'POST'
    }
    Life.Cities = $resource API.path('life/cities/:courseId'), {}, {
      get:
        method: 'GET'
        isArray: true
    }
    Life.entries = []
    Life

