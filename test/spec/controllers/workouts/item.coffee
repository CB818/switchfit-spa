'use strict'

describe 'Controller: WorkoutsItemCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  WorkoutsItemCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    WorkoutsItemCtrl = $controller 'WorkoutsItemCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
