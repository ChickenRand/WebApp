'use strict'

###*
 # @ngdoc function
 # @name webAppApp.controller:ExperimentDoodlejumpCtrl
 # @description
 # # ExperimentDoodlejumpCtrl
 # Controller of the webAppApp
###
angular.module('webAppApp')
  .controller 'ExperimentDoodlejumpCtrl', ($scope) ->
  	queue =
  		length: 0
  		estimated_time: 0
    request = $http.get "#{Globals.APIURL}/api/queue/state"
        request.success (data, status) =>
        	queue = data
        request.error (data, status) =>



