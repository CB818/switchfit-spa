'use strict'

describe 'Service: Diary', ->

  # load the service's module
  beforeEach module 'switchfitApp'

  # instantiate service
  Diary = {}
  beforeEach inject (_Diary_) ->
    Diary = _Diary_

  it 'should do something', ->
    expect(!!Diary).toBe true
