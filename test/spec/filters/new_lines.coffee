'use strict'

describe 'Filter: newLines', ->

  # load the filter's module
  beforeEach module 'switchfitApp'

  # initialize a new instance of the filter before each test
  newLines = {}
  beforeEach inject ($filter) ->
    newLines = $filter 'newLines'

  it 'should return the input prefixed with "newLines filter:"', ->
    text = 'angularjs'
    expect(newLines text).toBe ('newLines filter: ' + text)
