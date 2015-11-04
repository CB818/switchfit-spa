'use strict'

describe 'Service: Login', ->

  # load the service's module
  beforeEach module 'switchfitApp'

  # instantiate service
  Login = {}
  beforeEach inject (_Login_) ->
    Login = _Login_

  it 'should do something', ->
    expect(!!Login).toBe true
