'use strict'

angular.module('arlo.directives').directive "commentsPanel", ['$timeout', 'Comment', 'Session', ($timeout, Comment, Session) ->

  directive =
    templateUrl: "angular/partials/comment.html"
    restrict: "E"
    scope:
      commentableId: "@cidAttrs"
      commentableType: "@ctypeAttrs"

    link: (scope, element, attrs) ->
      scope.toggled = false
      scope.newComment = null
      scope.comments

      Session.requestCurrentUser().then ->
        scope.currentUser = Session.currentUser

      scope.toggle = ->
        if scope.toggled is true then scope.toggled = false else scope.toggled = true
        scope.comment = null

      scope.addComment = ->
        Comment.addComment(scope.commentableType, scope.commentableId, scope.newComment).then ->
          scope.comments = Comment.commentsList
          scope.toggled = false
          scope.comment = null

      scope.loadComments = ->
        Comment.loadComments(scope.commentableType, scope.commentableId).then ->
          scope.comments = Comment.commentsList

      $timeout(->
        scope.loadComments()
        return
      , 500)

  directive
]