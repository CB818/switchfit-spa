'use strict'

describe 'Controller: WarmupCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  WarmupCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    WarmupCtrl = $controller 'WarmupCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
