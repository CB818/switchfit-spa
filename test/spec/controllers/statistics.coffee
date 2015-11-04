'use strict'

describe 'Controller: StatisticsCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  StatisticsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    StatisticsCtrl = $controller 'StatisticsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
