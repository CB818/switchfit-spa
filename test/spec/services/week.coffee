'use strict'

describe 'Service: week', ->

  # load the service's module
  beforeEach module 'switchfitApp'

  # instantiate service
  week = {}
  beforeEach inject (_week_) ->
    week = _week_

  it 'should do something', ->
    expect(!!week).toBe true
