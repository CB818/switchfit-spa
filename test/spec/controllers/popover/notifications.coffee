'use strict'

describe 'Controller: PopoverNotificationsCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  PopoverNotificationsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    PopoverNotificationsCtrl = $controller 'PopoverNotificationsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
