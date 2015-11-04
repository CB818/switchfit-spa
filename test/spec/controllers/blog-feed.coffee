'use strict'

describe 'Controller: BlogFeedCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  BlogFeedCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    BlogFeedCtrl = $controller 'BlogFeedCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
