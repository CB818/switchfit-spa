'use strict'

describe 'Service: Day', ->

  # load the service's module
  beforeEach module 'switchfitApp'

  # instantiate service
  Day = {}
  beforeEach inject (_Day_) ->
    Day = _Day_

  it 'should do something', ->
    expect(!!Day).toBe true
