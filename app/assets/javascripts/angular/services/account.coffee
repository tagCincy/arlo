'user strict'

angular.module('arlo.services').factory 'Account', ['Restangular', (Restangular) ->

  service =

    getAccount: (id) ->
      Restangular.one('accounts', id).get({}).then (response) ->
        service.currentAccount = response
      , (response) ->
        console.log(response)

    currentAccount: null

  service

]