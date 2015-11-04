'use strict'

describe 'Directive: file', ->

  # load the directive's module
  beforeEach module 'switchfitApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<file></file>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the file directive'
