'use strict'

describe 'Controller: AcademyModuleCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  AcademyModuleCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AcademyModuleCtrl = $controller 'AcademyModuleCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
