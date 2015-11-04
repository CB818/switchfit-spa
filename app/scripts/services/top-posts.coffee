'use strict'

###*
 # @ngdoc service
 # @name switchfitApp.page
 # @description
 # # page
 # Service in the switchfitApp.
###
angular.module('switchfitApp')
.service 'TopPosts', (API, $resource) ->
  TopPosts = $resource API.path('life/top-posts'), {}, {
    get:
      method: 'GET',
      isArray: true
  }
  TopPosts
