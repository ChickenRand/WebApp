'use strict'

angular.module('webAppApp')
  .service 'User', () ->
    login: (email, password) ->
        console.log "Logging with #{email} and #{password}"
