'user strict'

angular.module('arlo.controllers').controller 'QuestionDashboardCtrl', ['$scope', 'Question', 'Session', ($scope, Question, Session) ->

  $scope.currentPage = 1
  $scope.numPerPage = 10
  $scope.maxSize = 5

  $scope.getCount = ->
    Question.getCount().then ->
      $scope.totalItems = Question.totalQuestions

  $scope.getCount()

  $scope.getPage = (o, p)->
    Question.getPage(o, p).then ->
      $scope.page = Question.currentPage

  $scope.getPage(0, null)

  $scope.nextPage = (page) ->
    o = page * 10
    $scope.getPage(o, true)

  return
]
