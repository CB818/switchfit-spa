'use strict'

###*
 # @ngdoc directive
 # @name switchfitApp.directive:btnLoading
 # @description
 # # btnLoading
###
angular.module('switchfitApp')
  .directive('btnLoading', ['$compile', 'usSpinnerService', ($compile, usSpinnerService) ->
      restrict: 'A'
      link: (scope, element, attrs) ->
        scope.spinnerId = 'spinner-' + Math.random().toString(36).substring(7)
        defaultOptions = {
          radius:4,
          width:2,
          length: 4,
          color: '#fff'
        }
        options = scope.$eval(attrs.btnLoadingOptions)
        options = angular.extend({}, defaultOptions, options)
        scope.customUsSpinnerOptions = options

        spin = angular.element('<span us-spinner="{{ customUsSpinnerOptions }}" spinner-key="{{spinnerId}}"></span>');
        element.prepend(spin)
        $compile(spin)(scope);

        scope.$watch(
          () ->
            return scope.$eval(attrs.btnLoading)
          ,
          (value) ->
            if(value)
              if (!attrs.hasOwnProperty('ngDisabled'))
                element.addClass('disabled').attr('disabled', 'disabled')
              element.addClass('btn-loading')
              # spin
              usSpinnerService.spin(scope.spinnerId)
            else
              if (!attrs.hasOwnProperty('ngDisabled'))
                element.removeClass('disabled').removeAttr('disabled')
              element.removeClass('btn-loading')
              # spin stop
              usSpinnerService.stop(scope.spinnerId)
        )
        return
    ]
  )