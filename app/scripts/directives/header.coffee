'use strict'

angular.module('webAppApp')
  .directive 'headerBar', (User) ->
    templateUrl: 'views/header.html'
    restrict: 'E'
    link: (scope, element, attrs) ->
        scope.pages = {
            "Accueil": url: "/#/"
            "Experimentations": url: "/#/experiments", onlyLogged: true
        }
        scope.showLoginModal = ->
            $("#loginModal").modal "show"
        scope.showRegisterModal = ->
            $("#registerModal").modal "show"
        scope.$root.$on "showLogin", scope.showLoginModal
        scope.$root.$on "showRegister", scope.showRegisterModal
        scope.login = (email, password) ->
            User.login(email, password).error (data, status) ->
                if status == 401
                    scope.error = "Mauvaise combinaison email / mot de passe"
                else
                    scope.error = "Impossible de se connecter au serveur"
