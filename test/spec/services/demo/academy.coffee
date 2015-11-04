'use strict'

describe 'Service: demo/academy', ->

  # load the service's module
  beforeEach module 'switchfitApp'

  # instantiate service
  demo/academy = {}
  beforeEach inject (_demo/academy_) ->
    demo/academy = _demo/academy_

  it 'should do something', ->
    expect(!!demo/academy).toBe true
