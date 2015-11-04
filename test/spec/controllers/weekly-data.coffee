'use strict'

describe 'Controller: WeeklyDataCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  WeeklyDataCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    WeeklyDataCtrl = $controller 'WeeklyDataCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
