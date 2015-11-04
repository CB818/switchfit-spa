'use strict'

describe 'Controller: DiaryCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  DiaryCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    DiaryCtrl = $controller 'DiaryCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
