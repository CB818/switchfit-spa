'use strict'

describe 'Service: Course', ->

  # load the service's module
  beforeEach module 'switchfitApp'

  # instantiate service
  Course = {}
  beforeEach inject (_Course_) ->
    Course = _Course_

  it 'should do something', ->
    expect(!!Course).toBe true
