'use strict'

angular.module('webAppApp')
  .constant 'Globals',
    APIURL: "http://127.0.0.1:9292"
    events:
        loginSuccess: "LOGINSUCCESS"
        loginFail: "LOGINFAIL"