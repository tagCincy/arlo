'user strict'

angular.module('arlo.services').factory 'Tag', ['Restangular', (Restangular) ->

  service =

    loadAllTags: ->
      Restangular.all('tags').getList().then (response)->
        service.allTags = response

    loadTags: (query) ->
      Restangular.all('tags').getList({q: query}).then (response) ->
        service.queriedTagList = response

    queriedTagList: null
    allTags: null


  service

]