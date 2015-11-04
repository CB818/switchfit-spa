'use strict'

describe 'Service: DemoMeals', ->

  # load the service's module
  beforeEach module 'switchfitApp'

  # instantiate service
  DemoMeals = {}
  beforeEach inject (_DemoMeals_) ->
    DemoMeals = _DemoMeals_

  it 'should do something', ->
    expect(!!DemoMeals).toBe true
