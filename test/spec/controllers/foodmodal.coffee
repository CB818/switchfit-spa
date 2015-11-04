'use strict'

describe 'Controller: FoodmodalCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  FoodmodalCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    FoodmodalCtrl = $controller 'FoodmodalCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
