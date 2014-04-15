#'use strict'
#
#angular.module('arlo.services').factory("Interceptor", ["$injector", "RetryQueue", ($injector, Queue) ->
#  (promise) ->
#    promise.then null, (originalResponse) ->
#
#      if originalResponse.status is 401
#        promise = Queue.pushRetryFn("unauthorized-server", retryRequest = ->
#          $injector.get("$http") originalResponse.config
#        )
#      promise
#
#]).config ["$httpProvider", ($httpProvider) ->
#  $httpProvider.responseInterceptors.push "Interceptor"
#]
