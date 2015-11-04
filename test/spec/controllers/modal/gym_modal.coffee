'use strict'

describe 'Controller: ModalGymModalCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  ModalGymModalCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ModalGymModalCtrl = $controller 'ModalGymModalCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
