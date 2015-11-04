'use strict'

describe 'Controller: QaMenuCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  QaMenuCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    QaMenuCtrl = $controller 'QaMenuCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
