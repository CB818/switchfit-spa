'use strict'

describe 'Service: life', ->

  # load the service's module
  beforeEach module 'switchfitApp'

  # instantiate service
  life = {}
  beforeEach inject (_life_) ->
    life = _life_

  it 'should do something', ->
    expect(!!life).toBe true
