'use strict'

describe 'Service: Workouts', ->

  # load the service's module
  beforeEach module 'switchfitApp'

  # instantiate service
  Workouts = {}
  beforeEach inject (_Workouts_) ->
    Workouts = _Workouts_

  it 'should do something', ->
    expect(!!Workouts).toBe true
