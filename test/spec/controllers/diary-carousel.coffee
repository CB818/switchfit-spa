'use strict'

describe 'Controller: DiaryCarouselCtrl', ->

  # load the controller's module
  beforeEach module 'switchfitApp'

  DiaryCarouselCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    DiaryCarouselCtrl = $controller 'DiaryCarouselCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
