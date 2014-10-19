'use strict'

angular.module('webAppApp')
  .service 'User', ($http, Globals, $rootScope) ->
    @infos = null

    @updateUser = () =>
        $http.get("#{Globals.APIURL}/api/user")
            .success (data, status) =>
                @infos = data

    #@updateUser()

    @login = (email, password) =>
        request = $http.post "#{Globals.APIURL}/api/user/login", {email, password}
        request.success (data, status) =>
            @infos = data
            $rootScope.$broadcast Globals.events.loginSuccess
        request.error (data, status) =>
            $rootScope.$broadcast Globals.events.loginFail
        return request

    @register = (infos) =>
        request = $http.post "#{Globals.APIURL}/api/user", infos
        request.success (data, status) =>
            @infos = data
            $rootScope.$broadcast Globals.events.loginSuccess
        request.error (data, status) =>
            $rootScope.$broadcast Globals.events.loginFail
        return request

    @logout = =>
        request = $http.post "#{Globals.APIURL}/api/user/logout"
        request.success (data, status) =>
            @infos = undefined
            $rootScope.$broadcast Globals.events.logoutSuccess
        request.error (data, status) =>
            @infos = undefined
            $rootScope.$broadcast Globals.events.logoutFail
        return request

    @modifyUser = (infos) =>
        request = $http.post "#{Globals.APIURL}/api/user", infos
        request.success (data, status) =>
            @infos = data
        return request

    return @
