'use strict'

describe 'Controller: CommunityLifeFeedCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  CommunityLifeFeedCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    CommunityLifeFeedCtrl = $controller 'CommunityLifeFeedCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
