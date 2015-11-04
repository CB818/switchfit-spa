'use strict'

###*
 # @ngdoc directive
 # @name switchfitApp.directive:printDom
 # @description
 # # printDom
###
angular.module('switchfitApp')
  .directive 'printDom', ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      header = '<html><head><meta charset="UTF-8"></head><body>'
      footer = '</body></html>'

      element.bind 'click', =>
        data = header + angular.element(attrs.printDom).html() + footer

        print = ->
          popupWindow = window.open()
          popupWindow.document.write(data)
          setTimeout ->
            popupWindow.print()
            popupWindow.close()
          , 500

        print()
