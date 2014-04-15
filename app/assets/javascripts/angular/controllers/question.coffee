'user strict'

angular.module('arlo.controllers').controller 'QuestionCtrl', ['$scope', '$state', '$stateParams', 'Session',
                                                               'Question', 'Page', 'Answer',
  ($scope, $state, $stateParams, Session, Question, Page, Answer) ->

    title = "Question ##{$stateParams.questionId}"
    Page.setTitle(title)

    $scope.question = {answers: []}

    $scope.toggleQuestionComment = ->
      if true then false else true

    Session.requestCurrentUser().then ->
      $scope.currentUser = Session.currentUser

    $scope.toggleQuestionComment = false

    $scope.getQuestion = ->
      Question.getQuestion($stateParams.questionId).then (response) ->
        $scope.question = Question.currentQuestion

    $scope.getQuestion()

    $scope.addAnswer = ->
      Answer.addAnswer($stateParams.questionId, $scope.newAnswer).then ->
        $scope.question.answers.push(Answer.newAnswer)
        $scope.newAnswer = ''

    $scope.makePublic = ->
      Question.makePublic($stateParams.questionId).then (response) ->
        $scope.question = Question.currentQuestion
]