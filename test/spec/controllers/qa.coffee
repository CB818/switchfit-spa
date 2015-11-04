'use strict'

describe 'Controller: QaCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  QaCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    QaCtrl = $controller 'QaCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
