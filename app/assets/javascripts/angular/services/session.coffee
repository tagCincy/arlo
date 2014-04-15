'use strict'

angular.module('arlo.services').factory "Session", ["$q", "$state", "Restangular",
  ($q, $state, Restangular) ->

    # Redirect to the given state (defaults to '/')
    redirect = (state) ->
      stateResolved = state or "question.dashboard"
      $state.transitionTo stateResolved

#    # Register a handler for when an item is added to the retry queue
#    queue.onItemAddedCallbacks.push (retryItem) ->
#      redirect() if queue.hasMore()

    # The public API of the service
    service =

      register: (user) ->
        data = {
          account: {
            username: user.username
            user_attributes: {
              first_name: user.first_name
              last_name: user.last_name
              email: user.email
              password: user.password
              password_confirmation: user.password_confirmation
            }
          }
        }

        Restangular.all('accounts').post(data).then (response) ->
          service.currentUser = response
          redirect 'account.show'
        , (error) ->
          console.log(error)

    # Attempt to authenticate a user by the given email and password
      login: (user) ->
        data = {
          user: {
            email: user.email
            password: user.password
          }
        }

        Restangular.all('users').customPOST(data,'sign_in').then (response) ->
          Restangular.all('account').customGET('current').then (response) ->
            service.currentUser = response

    # Logout the current user and redirect
      logout: ->
        Restangular.all('users').customDELETE('sign_out').then ->
          service.currentUser = null

    # Ask the backend to see if a user is already authenticated - this may be from a previous session.
      requestCurrentUser: ->
        if service.isAuthenticated()
          $q.when service.currentUser
        else
          Restangular.all('account').customGET('current').then (response) ->
            service.currentUser = response

    # Information about the current user
      currentUser: null

    # Is the current user authenticated?
      isAuthenticated: ->
        !!service.currentUser

      isGod: ->
        if service.isAuthenticated()
          for role in service.currentUser.roles
            if role.level is 99
              return true
        false

    service
]