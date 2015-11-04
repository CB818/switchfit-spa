'use strict'

###*
 # @ngdoc directive
 # @name switchfitApp.directive:file
 # @description
 # # file
###
angular.module('switchfitApp')
  .directive('file', ->
    require: "ngModel",
    restrict: 'A',
    link: ($scope, el, attrs, ngModel) ->
      el.bind 'change', (event) ->
        files = event.target.files;
        file = files[0];

        ngModel.$setViewValue(file);
        $scope.$apply()
  )
