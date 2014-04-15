'user strict'

angular.module('arlo.services').factory 'Answer', ['Restangular', (Restangular) ->

  service =
    addAnswer: (questionId, answer) ->
      data = {
        answer: {
          content: answer
        }
      }

      Restangular.one('questions', questionId).post('answers', data).then (response) ->
        service.newAnswer = (response)

    loadComments: (questionId) ->
      Restangular.one('questions', questionId).getList('answers').then (response) ->
        service.answerList = response


    newAnswer: null
    answerList: []

  service
]