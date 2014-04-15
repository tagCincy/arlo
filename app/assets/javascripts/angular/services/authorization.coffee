'use strict'

angular.module('arlo.services').provider "Authorization",

  requireAdminUser: ["Authorization", (Authorization) ->
    Authorization.requireAdminUser()
  ]

  requireAuthenticatedUser: ["Authorization", (Authorization) ->
    Authorization.requireAuthenticatedUser()
  ]

  $get: ["Session", "RetryQueue", (Session, Queue) ->
    service =
      
      # Require that there is an authenticated user
      # (use this in a route resolve to prevent non-authenticated users from entering that route)
      requireAuthenticatedUser: ->
        promise = Session.requestCurrentUser().then((userInfo) ->
          Queue.pushRetryFn "unauthenticated-client", service.requireAuthenticatedUser unless Session.isAuthenticated()
        )
        promise

      
      # Require that there is an administrator logged in
      # (use this in a route resolve to prevent non-administrators from entering that route)
      requireAdminUser: ->
        promise = Session.requestCurrentUser().then((userInfo) ->
          Queue.pushRetryFn "unauthorized-client", service.requireAdminUser  unless Session.isAdmin()
        )
        promise

    service
  ]
