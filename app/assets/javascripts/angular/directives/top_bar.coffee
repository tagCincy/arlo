'use strict'

angular.module('arlo.directives').directive "topBar", ["Session", "$state", (Session, $state) ->
  directive =
    templateUrl: "angular/partials/topbar.html"
    restrict: "E"
    replace: true
    scope: true
    link: ($scope, $element, $attrs, $controller) ->

      $scope.logout = ->
        Session.logout().then ->
          $state.go('question.dashboard')

      Session.requestCurrentUser().then ->
        $scope.currentUser = Session.currentUser

      $scope.$watch (->
        Session.currentUser
      ), (currentUser) ->
        $scope.currentUser = currentUser

        if currentUser is null then $scope.loggedIn = false else $scope.loggedIn = true
        $scope.$parent.loggedIn = $scope.loggedIn

      return
  directive
]
