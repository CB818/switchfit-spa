'use strict'

describe 'Directive: anchorScrollTrigger', ->

  # load the directive's module
  beforeEach module 'switchfitApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<anchor-scroll-trigger></anchor-scroll-trigger>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the anchorScrollTrigger directive'
