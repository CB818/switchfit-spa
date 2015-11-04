'use strict'

describe 'Controller: VideoModalsCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  VideoModalsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    VideoModalsCtrl = $controller 'VideoModalsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
