'use strict'

class TopTippsCtrl
  constructor: (@$scope, TippsData) ->
    $scope.items = TippsData.get()
    
    $scope.bubbling = false

    $scope.show_bubble = (tippId, domEl) =>
      $scope.bubbling = true
      offset = $("#tipps_" + tippId).offset()
      
      for item in $scope.items
      	if item.id == tippId
      	  break

      jQuery.alert item.text, {
      	title: item.title,
      	autoClose: false,
      	position: ['top-left', [offset.top, offset.left]],
      	type: "info",
      	minTop: 50,
      	isOnly: true,
      	onClose: () ->
      	  $scope.bubbling = false
      	  $scope.$apply()
      }
    $scope.hide_bubble = () =>
      $scope.bubbling = false
      $(".alert .close").trigger "click"

TopTippsCtrl.$inject = [ '$scope', 'TippsData']

angular.module('switchfitApp')
.controller 'TopTippsCtrl', TopTippsCtrl