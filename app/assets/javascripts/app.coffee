'use strict'

angular.module('arlo',
  ['ui.router', 'ui.bootstrap', 'restangular', 'arlo.services', 'arlo.controllers', 'arlo.directives'])

.config ['$httpProvider', ($httpProvider) ->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
]

.config ['$stateProvider', '$urlRouterProvider', '$httpProvider', ($stateProvider, $urlRouterProvider, $httpProvider) ->
  $httpProvider.defaults.headers.common["X-CSRF-Token"] = $("meta[name=csrf-token]").attr("content")
  $urlRouterProvider.when '/', '/questions/dashboard'

  $stateProvider
  .state 'question',
    url: '/questions'
    templateUrl: 'angular/question/layout.html'
    abstract: true
    data:
      requiresAuthorized: false
  .state 'question.dashboard',
    url: '/dashboard'
    templateUrl: 'angular/question/index.html'
    controller: 'QuestionDashboardCtrl'
    title: 'Dashboard'
  .state 'question.show',
    url: '/{questionId:[0-9]{1,8}}'
    templateUrl: 'angular/question/show.html'
    controller: 'QuestionCtrl'
  .state 'question.new',
    url: '/new?question'
    templateUrl: 'angular/question/new.html'
    controller: 'QuestionCreateCtrl'
    title: 'New Question'
    data:
      requiresAuthorized: true
  .state 'account',
    abstract: true
    url: '/account'
    templateUrl: 'angular/account/layout.html'
    title: 'Account'
    data:
      requiresAuthorized: false
  .state 'account.show',
    url: "/{accountId:[0-9]{1,8}}"
    templateUrl: 'angular/account/show.html'
    controller: 'AccountCtrl'
    title: 'Account #{accountId}'
  .state 'account.login',
    url: '/login?redirectTo&redirectData'
    templateUrl: 'angular/account/login.html'
    controller: 'SessionCtrl'
    title: 'Sign In'
  .state 'account.register',
    url: '/register'
    templateUrl: 'angular/account/new.html'
    controller: 'SessionCtrl'
    title: 'Sign Up'
  .state 'account.logout',
    url: '/logout'
    controller: 'SessionCtrl'
  .state 'group',
    abstract: true
    url: '/groups'
    templateUrl: 'angular/group/layout.html'
    title: 'Groups'
    data:
      requiresAuthorized: true
  .state 'group.dashboard',
    url: '/dashboard'
    templateUrl: 'angular/group/index.html'
    title: 'Group Dashboard'
    controller: 'GroupDashboardCtrl'
  .state 'group.show',
    url: '/{groupId:[0-9]{1,8}}'
    templateUrl: 'angular/group/show.html'
    title: 'Group'
    controller: 'GroupCtrl'
  .state 'group.new',
    url: '/new'
    templateUrl: 'angular/group/new.html'
    title: 'Create New Group'
    controller: 'GroupCreateCtrl'
]

.config ['RestangularProvider', (RestangularProvider) ->
  RestangularProvider.setBaseUrl('/api/service/v1')
]

.run(['$rootScope', '$state', '$location', '$http', '$window', 'Session', 'Page', 'Restangular',
    ($rootScope, $state, $location, $http, $window, Session, Page, Restangular) ->
      Restangular.setErrorInterceptor (response) ->
        unless response.config.url == "/api/service/v1/account/current"
          if response.status == 401
            $state.go('account.login')
          else if response.status == 403
            domainArray = $location.host().split('.')
            if domainArray.length > 2
              $window.location = 'http://' +
                domainArray[domainArray.length - 2] + '.' +
                domainArray[domainArray.length - 1] + '/#/'
            else
              $window.location = 'http://' + $location.host() + '/#/'
          else if response.status == 400
              $state.go('question.dashboard')

      # previous state handling
      $rootScope.previousState = {}
      $rootScope.redirectState = {}
      $rootScope.$on '$stateChangeSuccess', (ev, toState, toParams, fromState, fromParams) ->
        $rootScope.$broadcast 'state.update', toState
        $rootScope.previousState.name = fromState.name
        $rootScope.previousState.params = fromParams

      # Initial Default State (gets set later after requesting settings)
      DEFAULT_STATE = 'question.dashboard'

      $rootScope.$on '$stateChangeStart', (ev, to, toParams, from, fromParams) ->
        Page.setTitle(to.title)
        if to.data.requiresAuthorized
          Session.requestCurrentUser().then ->
            currentUser = Session.currentUser
            if currentUser is null
              ev.preventDefault()
              $rootScope.redirectState = {to: to.name, paramData: toParams}
              $state.go('account.login')
  ])