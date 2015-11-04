'use strict'

describe 'Controller: AcademyCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  AcademyCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AcademyCtrl = $controller 'AcademyCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
