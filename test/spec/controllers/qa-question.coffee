'use strict'

describe 'Controller: QaQuestionCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  QaQuestionCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    QaQuestionCtrl = $controller 'QaQuestionCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
