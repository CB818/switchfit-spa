'use strict'

angular.module('switchfitApp')
  .service 'API', ->
    API =
      path: (path) -> "/api/v1/frontend/#{path}"
        
    API