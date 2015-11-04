'use strict'

###*
 # @ngdoc directive
 # @name switchfitApp.directive:anchorScrollTrigger
 # @description
 # # anchorScrollTrigger
###
angular.module('switchfitApp')
  .directive('anchorScrollTrigger', ['$timeout', '$location', ($timeout, $location) ->
      restrict: 'E'
      link: (scope, elem, attrs, ctrl) ->
        if $location.hash().length > 0
          $timeout () =>
            anchorElem = angular.element('#' + $location.hash())
            top = anchorElem.offset().top
            console.log(top)
            angular.element('html, body').stop().animate({
              'scrollTop': top
            }, 300, 'swing');
          , 300
    ]
  )
