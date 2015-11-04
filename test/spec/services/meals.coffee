'use strict'

describe 'Service: Meals', ->

  # load the service's module
  beforeEach module 'switchfitApp'

  # instantiate service
  Meals = {}
  beforeEach inject (_Meals_) ->
    Meals = _Meals_

  it 'should do something', ->
    expect(!!Meals).toBe true
