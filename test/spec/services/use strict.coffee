'use strict'

describe 'Service: UseStrict', ->

  # load the service's module
  beforeEach module 'switchfitApp'

  # instantiate service
  UseStrict = {}
  beforeEach inject (_UseStrict_) ->
    UseStrict = _UseStrict_

  it 'should do something', ->
    expect(!!UseStrict).toBe true
