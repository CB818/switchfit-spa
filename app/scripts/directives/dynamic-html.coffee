'use strict'

###*
 # @ngdoc directive
 # @name switchfitApp.directive:dynamicHtml
 # @description
 # # dynamicHtml
###
angular.module('switchfitApp')
  .directive('dynamicHtml', ['$compile', '$sce', '$parse', ($compile, $sce, $parse) ->
      restrict: 'A'
      replace: true,
      link: (scope, element, attr) ->
        parsed = $parse(attr.dynamicHtml)
        getStringValue = ->
          (parsed(scope) or "").toString()
        element.addClass("ng-binding").data "$binding", attr.dynamicHtml

        scope.$watch getStringValue, (value) ->
          element.html value or ""
          $compile(element.contents())(scope)
    ]
  )
