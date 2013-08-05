

ngapp_service = angular.module("ngapp.service", [])


class Notification
  constructor: (@timeout) ->

  loading: (promise) ->
    @timeout.cancel @timeoutId if @timeoutId?

    @timeoutId = @timeout( ->
      $('.alert-box').slideDown()
    , 0)

    promise.then ->
      $('.alert-box').slideUp()


ngapp_service.factory("notification",
  ['$timeout', ($timeout) ->
    new Notification $timeout
  ]
)

ngapp_service.factory("utilities", 
  [ '$timeout', '$http', '$q', ($timeout, $http, $q) ->
    return {
      initialization: ->
        $timeout -> $timeout ->
          $('#all-posts time.timeago').timeago()
          $('textarea').autosize {append: "\n"}
          $('textarea').css 'resize', 'vertical'
    }
  ]
)
