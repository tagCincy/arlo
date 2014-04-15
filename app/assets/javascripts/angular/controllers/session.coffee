'use strict'

angular.module('arlo.controllers').controller 'SessionCtrl', ["$scope", "$rootScope", "$state", "Session",
  ($scope, $rootScope, $state, Session) ->
    $scope.currentUser = {}
    $scope.loggedIn
    $scope.authError

    $scope.login = ->
      Session.login($scope.user).then ->
        if Session.isAuthenticated()
          if $rootScope.redirectState.to is undefined
            $state.go('question.dashboard')
          else
            paramData = $rootScope.redirectState.paramData
            $state.go($rootScope.redirectState.to, paramData)

    $scope.logout = ->
      Session.logout()

    $scope.register = ->
      Session.register($scope.user)
]
