'use strict'

angular.module('webAppApp')
  .directive('footerBar', () ->
    templateUrl: 'views/footer.html'
    restrict: 'E'
    link: (scope, element, attrs) ->
  )
