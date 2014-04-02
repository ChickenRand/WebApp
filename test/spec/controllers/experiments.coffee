'use strict'

describe 'Controller: ExperimentsCtrl', () ->

  # load the controller's module
  beforeEach module 'webAppApp'

  ExperimentsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ExperimentsCtrl = $controller 'ExperimentsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3
