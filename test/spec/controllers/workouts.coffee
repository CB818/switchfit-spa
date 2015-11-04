'use strict'

describe 'Controller: WorkoutsCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  WorkoutsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    WorkoutsCtrl = $controller 'WorkoutsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
