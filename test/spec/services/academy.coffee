'use strict'

describe 'Service: Academy', ->

  # load the service's module
  beforeEach module 'switchfitApp'

  # instantiate service
  Academy = {}
  beforeEach inject (_Academy_) ->
    Academy = _Academy_

  it 'should do something', ->
    expect(!!Academy).toBe true
