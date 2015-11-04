'use strict'

###*
 # @ngdoc function
 # @name switchfitApp.controller:CommunityLifeFeedCtrl
 # @description
 # # CommunityLifeFeedCtrl
 # Controller of the switchfitApp
###
class CommunityLifeFeedCtrl
  constructor: (@$scope, @Life, @$rootScope, @$modal) ->
    @entriesSize = 20
    @entriesShown = 1

    @Life.entries = @Life.get()
    @Life.entries.$promise.then () =>
      @$scope.entries = @Life.entries

      @$scope.entriesLimit = () =>
        return @entriesSize * @entriesShown

      @$scope.hasMoreEntriesToShow = () =>
        return @entriesShown < (@$scope.entries.length / @entriesSize)

      @$scope.showMoreEntries = () =>
        @entriesShown = @entriesShown + 1

      @$scope.openCarousel = (index) =>
        scopeModal = @$rootScope.$new()
        scopeModal.activeSlide = index
        @$modal.open({
          templateUrl: 'views/modals/carouselLifeModal.html'
          windowClass: 'life-carousel carousel frameless modal-md'
          controller: 'ModalLifeCarouselCtrl',
          scope: scopeModal
        })

CommunityLifeFeedCtrl.$inject = [ '$scope', 'Life', '$rootScope', '$modal']

angular.module('switchfitApp.community').controller 'CommunityLifeFeedCtrl', CommunityLifeFeedCtrl