'use strict'

describe 'Controller: StatisticsCravingsHungerMoodCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  StatisticsCravingsHungerMoodCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    StatisticsCravingsHungerMoodCtrl = $controller 'StatisticsCravingsHungerMoodCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
