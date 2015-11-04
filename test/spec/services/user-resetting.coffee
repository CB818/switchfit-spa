'use strict'

describe 'Service: userResetting', ->

  # load the service's module
  beforeEach module 'switchfitApp'

  # instantiate service
  userResetting = {}
  beforeEach inject (_userResetting_) ->
    userResetting = _userResetting_

  it 'should do something', ->
    expect(!!userResetting).toBe true
