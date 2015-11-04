'use strict'

class ModalCities
  constructor: (@$scope, @$rootScope, @$modal) ->
    @$scope.openPointExplanationModal = () =>
      scopeModal = @$rootScope.$new()
      modalOptions =
        templateUrl: "views/modals/pointExplanation.html"
        class: "modal-md"
        controller: 'PointsCtrl'
        scope: scopeModal
      @$modal.open modalOptions

ModalCities.$inject = [ '$scope', '$rootScope', '$modal' ]

angular.module('switchfitApp.community')
  .controller 'ModalCitiesCtrl', ModalCities
