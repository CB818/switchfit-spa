'use strict'

describe 'Service: demo/workouts', ->

  # load the service's module
  beforeEach module 'switchfitApp'

  # instantiate service
  demo/workouts = {}
  beforeEach inject (_demo/workouts_) ->
    demo/workouts = _demo/workouts_

  it 'should do something', ->
    expect(!!demo/workouts).toBe true
