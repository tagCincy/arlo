'use strict'

angular.module('arlo.directives').directive 'autoComplete', ['$http', '$timeout', ($http, $timeout) ->
  restrict: 'E'
  scope:
    model: '@modelAttrs'
    enter: '&onEnter'
    url: '@urlAttrs'
#  template: '<input type="text" placeholder="" ng-model="model.label">'
  template: '<input type="text" class="form-control" placeholder="">'

  controller: ($scope, $element, $attrs) ->
    $scope.updateModel = (item) ->
      $scope.model = item
      $scope.$apply()

    $scope.draw = ->
      $input = angular.element($element.children()[0])
      $input.attr('placeholder', $attrs.placeholder)
      $input.val($scope.model.label)

      $input.on "click change keyup select", (event) ->
        val = $(this).val()
        if val == ""
          $scope.updateModel('')
          $input.focus().val('').autocomplete('close')
        else if val != $scope.model.label
          $scope.updateModel({id: null, label: null, value: val})

      $input.autoComplete(
        minLength: 2
        source: (request, response) ->
          url = $scope.url + request.term
          $http.get(url).success (data) ->
            response data
        focus: (event, ui) ->
          $input.val(ui.item.label)
          false
        select: (event, ui) ->
          $scope.updateModel(ui.item)
      ).data("ui-autocomplete")._renderItem = (ul, item) ->
        $("<li></li>").data("ui-autocomplete-item", item).append("<a>" + item.label + "</a>").appendTo ul

      $input.on 'keypress', (event) ->
        code = event.keyCode || event.which
        if code == 13
          $scope.enter()
          $input.focus().val('').autocomplete('close')

  link: (scope, element, attrs, controller) ->
    $timeout (->
      if typeof(scope.model) != "undefined" && typeof(scope.url) != "undefined"
        scope.draw()
    ), 100
    scope.$watch 'model', ->
      if typeof(scope.model) != "undefined" && typeof(scope.url) != "undefined"
        scope.draw()
]
