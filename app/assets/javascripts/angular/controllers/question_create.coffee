angular.module('arlo.controllers').controller 'QuestionCreateCtrl', ['$scope', '$state', '$stateParams', 'Session',
                                                                     'Question', 'Page', 'Tag'
  ($scope, $state, $stateParams, Session, Question, Page, Tag) ->
    $scope.question = {tags: []}
    $scope.question.title = $stateParams.question

    Page.setTitle("Ask New Question")

    Session.requestCurrentUser().then ->
      $scope.currentUser = Session.currentUser

    Tag.loadAllTags().then ->
      $scope.tags = Tag.allTags

    $scope.createQuestion = ->
      Question.createQuestion($scope.question).then ->
        newQuestion = Question.currentQuestion
        $state.go('question.show', {questionId: newQuestion.id})

    $scope.loadTags = (query)->


      Tag.loadTags(query).then ->
        queriedTags = []
        tags = Tag.queriedTagList
        angular.forEach(tags, (item)->
          queriedTags.push item.name
        )
        return queriedTags

    $scope.enableAdd = ->
      console.log "Enabled"

    $scope.selectedTags = []

    $scope.addTag = (tagName)->
      $scope.selectedTags.push(tagName)

      angular.forEach($scope.tags, (item)->
        if item.name is tagName
          $scope.question.tags.push(item.id)
      )

      $scope.enteredValue = ""

]