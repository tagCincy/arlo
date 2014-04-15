'user strict'

angular.module('arlo.controllers').controller 'GroupCtrl', ['$scope', '$state', '$stateParams', '$location',
                                                                  'Session', 'Account', 'Group', 'Page'
  ($scope, $state, $stateParams, $location, Session, Account, Group, Page) ->

    Session.requestCurrentUser().then ->
      $scope.currentUser = Session.currentUser

    $scope.getGroup = ->
      Group.getGroup($stateParams.groupId).then ->
        $scope.group = Group.currentGroup

    $scope.getGroup()
]