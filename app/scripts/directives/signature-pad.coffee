'use strict'

###*
 # @ngdoc directive
 # @name switchfitApp.directive:signaturePad
 # @description
 # # signaturePad
###
angular.module('switchfitApp')
  .directive('signaturePad', ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      scope.$parent.signaturePadApi = $(element).signaturePad(scope.$eval(attrs.signaturePad));
  )