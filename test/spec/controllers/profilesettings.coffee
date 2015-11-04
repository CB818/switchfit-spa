'use strict'

describe 'Controller: ProfilesettingsCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  ProfilesettingsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ProfilesettingsCtrl = $controller 'ProfilesettingsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
