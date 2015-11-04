'use strict'

describe 'Controller: ModalFoodModalCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  ModalFoodModalCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ModalFoodModalCtrl = $controller 'ModalFoodModalCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
