'use strict'

angular.module('arlo.controllers').controller 'AccountCtrl', ['$scope', '$state', '$stateParams', 'Session', 'Account',
  ($scope, $state, $stateParams, Session, Account) ->

    $scope.getAccount = ->
      Account.getAccount($stateParams.accountId).then (response) ->
        $scope.account = response

    $scope.getAccount()

]