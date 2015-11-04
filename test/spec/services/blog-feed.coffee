'use strict'

describe 'Service: blogFeed', ->

  # load the service's module
  beforeEach module 'switchfitApp'

  # instantiate service
  blogFeed = {}
  beforeEach inject (_blogFeed_) ->
    blogFeed = _blogFeed_

  it 'should do something', ->
    expect(!!blogFeed).toBe true
