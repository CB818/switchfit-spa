'use strict'

describe 'Controller: ResettingResetCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  ResettingResetCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ResettingResetCtrl = $controller 'ResettingResetCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
