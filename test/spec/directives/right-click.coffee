'use strict'

describe 'Directive: rightClick', ->

  # load the directive's module
  beforeEach module 'switchfitApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<right-click></right-click>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the rightClick directive'
