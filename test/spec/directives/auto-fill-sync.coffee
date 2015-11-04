'use strict'

describe 'Directive: autoFillSync', ->

  # load the directive's module
  beforeEach module 'switchfitApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<auto-fill-sync></auto-fill-sync>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the autoFillSync directive'
