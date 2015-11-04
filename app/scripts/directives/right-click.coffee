'use strict'

###*
 # @ngdoc directive
 # @name switchfitApp.directive:rightClick
 # @description
 # # rightClick
###
angular.module('switchfitApp')
  .directive('ngRightClick', ['$document', ($document) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      element.bind "contextmenu", (event) ->
        scope.$apply ->
          event.preventDefault()
          event.stopPropagation()
  ]
  )
