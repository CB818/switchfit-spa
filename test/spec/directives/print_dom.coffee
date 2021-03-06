'use strict'

describe 'Directive: printDom', ->

  # load the directive's module
  beforeEach module 'switchfitApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<print-dom></print-dom>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the printDom directive'
