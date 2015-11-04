'use strict'

describe 'Controller: ModalAddDiaryEntryCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  ModalAddDiaryEntryCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ModalAddDiaryEntryCtrl = $controller 'ModalAddDiaryEntryCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
