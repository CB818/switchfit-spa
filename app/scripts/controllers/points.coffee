'use strict'
angular.module('switchfitApp.points', ['ui.router'])


class Points
  constructor : (@$scope, @Points, @$rootScope, @$timeout, @$modal) ->
    explanationModalOpen = false
    globalPoints = @$rootScope.$new()
    @$rootScope.globalPoints = globalPoints

    globalPoints.$on 'updatePoints', () =>
        @$scope.pointsUpdate()
        undefined

    @$scope.pointsUpdate = () =>
      @$scope.show = false
      @points = @Points.get()
      @points.$promise.then (result) =>
        @$scope.points = result
        @$scope.added = result.added
        @$scope.pointsAutoClose()

    @$scope.openPointExplanationModal = () =>
      if !explanationModalOpen
        scopeModal = @$rootScope.$new()
        modalOptions =
          templateUrl: "views/modals/pointExplanation.html"
          class: "modal-md"
          controller: 'PointsCtrl'
          scope: scopeModal
        @$modal.open modalOptions
      else
        @$timeout () =>
          angular.element('.close').trigger('click')
      explanationModalOpen = !explanationModalOpen

    @$scope.togglePoints = (show) =>
      @$scope.added = 0
      @$scope.show = show

    @$scope.pointsAutoClose = () =>
      if @$scope.show or @$scope.added > 0
        @$timeout () =>
          @$scope.added = 0
          @$scope.show = false
        , 5000;

    @$scope.pointsUpdate()


Points.$inject = ['$scope', 'Points', '$rootScope', '$timeout', '$modal']

angular.module('switchfitApp.points').controller 'PointsCtrl', Points