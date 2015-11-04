'use strict'

describe 'Controller: AcademyFinalTestCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  AcademyFinalTestCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AcademyFinalTestCtrl = $controller 'AcademyFinalTestCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
