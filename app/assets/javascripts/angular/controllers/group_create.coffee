'user strict'

angular.module('arlo.controllers').controller 'GroupCreateCtrl', ['$scope', '$state', '$stateParams', '$location',
                                                                  'Session', 'Account', 'Group', 'Page'
  ($scope, $state, $stateParams, $location, Session, Account, Group, Page) ->
    Session.requestCurrentUser().then ->
      $scope.currentUser = Session.currentUser

    $scope.createGroup = ->
      Group.createGroup($scope.group).then ->
        $scope.newGroup = Group.currentGroup
        $state.go('group.show', {questionId: $scope.newGroup.id})



]