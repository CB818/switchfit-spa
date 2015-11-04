'use strict'

describe 'Directive: floatModel', ->

  # load the directive's module
  beforeEach module 'switchfitApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<float-model></float-model>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the floatModel directive'
