'use strict'

describe 'Service: Globals', () ->

  # load the service's module
  beforeEach module 'webAppApp'

  # instantiate service
  Globals = {}
  beforeEach inject (_Globals_) ->
    Globals = _Globals_

  it 'should do something', () ->
    expect(!!Globals).toBe true
