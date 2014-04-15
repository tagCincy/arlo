'use strict'

angular.module('arlo.controllers').controller 'PageCtrl', ['$scope', 'Page', ($scope, Page) ->
  $scope.Page = Page
]