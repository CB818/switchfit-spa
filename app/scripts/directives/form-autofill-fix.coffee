'use strict'

angular.module('switchfitApp')
  .directive "formAutofillFix", ->
    (scope, elem, attrs) ->

      elem.prop "method", "POST"

      if attrs.ngSubmit
        setTimeout (->
          elem.unbind("submit").submit (e) ->
            e.preventDefault()
            elem.find("input, textarea, select").trigger("input").trigger("change").trigger "keydown"
            scope.$apply attrs.ngSubmit
            return

          return
        ), 0
      return