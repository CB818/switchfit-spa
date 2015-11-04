'use strict'

describe 'Controller: FoodmodalinstanceCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  FoodmodalinstanceCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    FoodmodalinstanceCtrl = $controller 'FoodmodalinstanceCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
