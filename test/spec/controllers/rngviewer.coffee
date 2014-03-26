'use strict'

describe 'Controller: RngviewerCtrl', () ->

  # load the controller's module
  beforeEach module 'webAppApp'

  RngviewerCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    RngviewerCtrl = $controller 'RngviewerCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3
