'use strict'

angular.module('webAppApp')
  .directive 'headerBar', (User, $location) ->
    templateUrl: 'views/header.html'
    restrict: 'E'
    link: (scope, element, attrs) ->
        $('.dropdown-toggle').dropdown()
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
        scope.logout = User.logout
        scope.login = (email, password) ->
            User.login(email, password).error (data, status) ->
                if status == 401
                    scope.error = "Mauvaise combinaison email / mot de passe"
                else
                    scope.error = "Impossible de se connecter au serveur"
            .success (data, status) ->
                $("#loginModal").modal "hide"
        scope.register = (user) ->
            User.register(user)

        scope.$root.$on "$routeChangeStart", (event, currRoute, prevRoute) ->
            $location.path "/" if scope.pages.Experimentations.onlyLogged and not User.infos