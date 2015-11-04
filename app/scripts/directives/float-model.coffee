'use strict'

###*
 # @ngdoc directive
 # @name switchfitApp.directive:floatModel
 # @description
 # # floatModel
###
angular.module('switchfitApp')
  .directive 'floatModel', ->
    require: "ngModel"
    restrict: 'A'
    link: (scope, element, attrs, ctrl) ->
      ctrl.$parsers.unshift (viewValue) ->
        value = viewValue.replace(",",".")
        parseFloat(value)

      return