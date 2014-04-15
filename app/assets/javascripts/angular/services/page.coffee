'use strict'

angular.module('arlo.services').factory "Page", ->

  title = null

  title: ->
    "Arlo" + (if title then " - "+title else "")
  setTitle: (newTitle) ->
    title = newTitle