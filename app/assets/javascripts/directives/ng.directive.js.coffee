

angular.module("ngapp.directive", [])
  .directive('ngappNotify', ->
    {
      restrict: 'A'
      template:
        '<div class="alert-box alert" data-alert style="display:none">
          <a href="javascript:location.reload()">reload</a>
          <i class="icon-info-sign"></i>
          <span id="notification-message"></span>
        </div>'
      replace: true
      scope: false
      link: (scope, element, attrs) ->
        attrs.$observe 'ngappNotify', (value) ->
          if value? and value != ''
            $(element).find('#notification-message').text value
            delay = parseInt attrs['delay']
            $(element).delay(delay).slideDown()
          else
            $(element).stop(true, false).slideUp()
    }
  ).directive('ngappTimeago', ['$timeout', ($timeout)->
    {
      restrict: 'A'
      template: '<time></time>'
      replace: true
      scope: false
      link: (scope, element, attrs) ->
        timeoutId = null
        tick = ->
          time = attrs['ngappTimeago']
          $(element).text moment(time)?.fromNow()
          timeoutId = $timeout tick, 1000
        tick()
        element.on '$destroy', -> $timeout.cancel timeoutId
    }
  ]).directive('ngappPost', ['$q', ($q) ->
    {
      restrict: 'E'
      template:
        '<div class="row">
          <div class="large-1 columns">
            <img class="radius" ng-src="{{image}}" />
          </div>
          <div class="large-11 columns">
            <span class="post-id">
              {{id}}
            </span>
            <div class="timeago" ngapp-timeago="{{time}}"></div>
            <a class="delete-button" ng-click="{{deleteCallback}}">
              <i class="icon-remove-sign"></i>
            </a>
            <pre>{{post}}</pre>
          </div>
        </div>'
      replace: true
      scope:
        image: '@userPhoto'
        id: '@postId'
        time: '@postTime'
        deleteCallback: '@deletePost'
        post: '@postMessage'
    }
  ])

