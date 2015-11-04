'use strict'

###*
 # @ngdoc filter
 # @name switchfitApp.filter:newLines
 # @function
 # @description
 # # newLines
 # Filter in the switchfitApp.
###
angular.module('switchfitApp')
  .filter 'newLines', ->
    (text) ->
      if text?
        text.replace /\n/g, '<br/>'
