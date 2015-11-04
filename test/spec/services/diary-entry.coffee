'use strict'

describe 'Service: DiaryEntry', ->

  # load the service's module
  beforeEach module 'switchfitApp'

  # instantiate service
  DiaryEntry = {}
  beforeEach inject (_DiaryEntry_) ->
    DiaryEntry = _DiaryEntry_

  it 'should do something', ->
    expect(!!DiaryEntry).toBe true
