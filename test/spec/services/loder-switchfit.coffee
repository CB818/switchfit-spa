'use strict'

describe 'Service: loderSwitchfit', ->

  # load the service's module
  beforeEach module 'switchfitApp'

  # instantiate service
  loderSwitchfit = {}
  beforeEach inject (_loderSwitchfit_) ->
    loderSwitchfit = _loderSwitchfit_

  it 'should do something', ->
    expect(!!loderSwitchfit).toBe true
