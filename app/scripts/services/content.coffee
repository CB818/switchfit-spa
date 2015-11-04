'use strict'

###*
 # @ngdoc service
 # @name switchfitApp.page
 # @description
 # # page
 # Service in the switchfitApp.
###
angular.module('switchfitApp')
  .service 'Content',  (API, $resource) ->
    Content = $resource API
    Content.Page = $resource API.path('content/pages/:slug'), {}, {}
    Content.Block = $resource API.path('content/blocks/:slug'), {}, {}
    Content
