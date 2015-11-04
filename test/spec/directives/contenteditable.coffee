'use strict'

describe 'Directive: contenteditable', ->

  # load the directive's module
  beforeEach module 'switchfitApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<contenteditable></contenteditable>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the contenteditable directive'
