'user strict'

angular.module('arlo.services').factory 'Question', ['Restangular', (Restangular) ->
  service =

    getPublicQuestions: ->
      Restangular.all('questions').getList({q: 'public'}).then (response) ->
        service.questionsArray = response
      , (error) ->
        console.log(error)

    getPage: (offset, pub) ->
      Restangular.all('questions').getList({o: offset, p: pub}).then (response) ->
        service.currentPage = response

    getCount: ->
      Restangular.all('question').customGET('count').then (response) ->
        service.totalQuestions = response

    getQuestion: (id) ->
      Restangular.one('questions', id).get().then (response) ->
        service.currentQuestion = response

    createQuestion: (question) ->
      data = {
        question: {
          title: question.title
          content: question.content
          tag_ids: question.tags
        }
      }

      Restangular.all('questions').post(data).then (response) ->
        service.currentQuestion = response

    addComment: (comment, id) ->
      data = {
        comment: {
          content: comment
        }
      }

      Restangular.one('questions', id).post('comments', data).then (response) ->
        service.newComment = response


    addAnswer: (answer, id) ->

    makePublic: (id) ->
      Restangular.one('questions', id).patch({question:{public:true}}).then (response) ->
        service.currentQuestion = response

    questionsArray: null
    totalQuestions: null
    currentPage: null
    currentQuestion: null
    newComment: null

  service

]