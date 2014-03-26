'use strict'

describe 'Directive: header', () ->

  # load the directive's module
  beforeEach module 'webAppApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<header></header>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the header directive'
