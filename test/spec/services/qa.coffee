'use strict'

describe 'Service: qa', ->

  # load the service's module
  beforeEach module 'switchfitApp'

  # instantiate service
  qa = {}
  beforeEach inject (_qa_) ->
    qa = _qa_

  it 'should do something', ->
    expect(!!qa).toBe true
