'use strict'

describe 'Controller: ModalDiaryCarouselCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  ModalDiaryCarouselCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ModalDiaryCarouselCtrl = $controller 'ModalDiaryCarouselCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
