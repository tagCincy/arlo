'user strict'

angular.module('arlo.controllers').controller 'GroupDashboardCtrl', ['$scope', '$state', '$stateParams', '$location', 'Session',
                                                                     'Account', 'Group', 'Page'
  ($scope, $state, $stateParams, $location, Session, Account, Group, Page) ->
    Session.requestCurrentUser().then ->
      $scope.currentUser = Session.currentUser

    $scope.IsAdmin = ->
      $scope.currentUser.role is 'admin' || $scope.currentUser.role is 'super'

    $scope.getGroups = ->
      Group.getGroups().then (response) ->
        $scope.groups = Group.groupsList

    $scope.getGroups()

    $scope.baseUrl = ->
      locArray = $location.host().split('.')

      if locArray.length > 2
        "#{locArray[locArray.length - 2]}.#{locArray[locArray.length - 1]}"
      else
        "#{$location.host()}"
]