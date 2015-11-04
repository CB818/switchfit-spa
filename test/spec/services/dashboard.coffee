'use strict'

describe 'Service: Dashboard', ->

  # load the service's module
  beforeEach module 'switchfitApp'

  # instantiate service
  Dashboard = {}
  beforeEach inject (_Dashboard_) ->
    Dashboard = _Dashboard_

  it 'should do something', ->
    expect(!!Dashboard).toBe true
