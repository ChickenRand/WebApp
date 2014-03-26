'use strict'

angular.module('webAppApp')
  .directive('headerBar', (User) ->
    templateUrl: 'views/header.html'
    restrict: 'E'
    link: (scope, element, attrs) ->
        scope.pages = {
            "Accueil": "/#/"
            "Experimentation": "/#/experiments"
        }
        scope.showLoginModal = ->
            $("#loginModal").modal "show"
        scope.$root.$on "showLogin", scope.showLoginModal
        scope.login = ->
            console.log "coucou", scope
            User.login scope.loginEmail, scope.loginPassword
  )
