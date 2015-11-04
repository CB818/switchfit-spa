'use strict'

describe 'Service: DiaryPictures', ->

  # load the service's module
  beforeEach module 'switchfitApp'

  # instantiate service
  DiaryPictures = {}
  beforeEach inject (_DiaryPictures_) ->
    DiaryPictures = _DiaryPictures_

  it 'should do something', ->
    expect(!!DiaryPictures).toBe true
