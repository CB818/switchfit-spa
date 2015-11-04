'use strict'

describe 'Controller: StatisticsCigarettesGlucoseCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  StatisticsCigarettesGlucoseCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    StatisticsCigarettesGlucoseCtrl = $controller 'StatisticsCigarettesGlucoseCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
