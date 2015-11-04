'use strict'

describe 'Controller: AcademyFinalCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  AcademyFinalCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AcademyFinalCtrl = $controller 'AcademyFinalCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
