'use strict'

describe 'Directive: btnLoading', ->

  # load the directive's module
  beforeEach module 'switchfitApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<btn-loading></btn-loading>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the btnLoading directive'
