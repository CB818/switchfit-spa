'use strict'

describe 'Controller: StatisticsWeightWaterFitnessCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  StatisticsWeightWaterFitnessCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    StatisticsWeightWaterFitnessCtrl = $controller 'StatisticsWeightWaterFitnessCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
