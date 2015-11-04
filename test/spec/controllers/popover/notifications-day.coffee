'use strict'

describe 'Controller: PopoverNotificationsDayCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  PopoverNotificationsDayCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    PopoverNotificationsDayCtrl = $controller 'PopoverNotificationsDayCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
