'use strict'

angular.module('arlo.services').factory 'Group', ['Restangular', (Restangular) ->

  service =
    getGroups: ->
      Restangular.all('groups').getList().then (response) ->
        service.groupsList = response

    getGroup: (id) ->
      Restangular.one('groups', id).get().then (response) ->
        service.currentGroup = response

    createGroup: (group)->
      data = {
        group: {
          name: group.name
          code: group.code
          description: group.description
        }
      }
      Restangular.all('groups').post(data).then (response) ->
        service.currentGroup = response

    groupsList: null
    currentGroup: null

  service

]