'use strict'

angular.module('webAppApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute'
])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/rngviewer',
        templateUrl: 'views/rngviewer.html'
        controller: 'RngviewerCtrl'
      .when '/experiments',
        templateUrl: 'views/experiments.html'
        controller: 'ExperimentsCtrl'
      .otherwise
        redirectTo: '/'
