'user strict'

angular.module('arlo.services').factory 'Comment', ['Restangular', (Restangular) ->

  service =
    addComment: (type, id, comment) ->
      data = {
        comment: {
          content: comment
        }
      }

      Restangular.one(type, id).post('comments', data).then (response) ->
        service.commentsList.push(response)

    loadComments: (type, id) ->
      Restangular.one(type, id).getList('comments').then (response) ->
        service.commentsList = response


    newComment: null
    commentsList: null

  service
]