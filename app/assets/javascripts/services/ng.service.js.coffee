

ngapp_service = angular.module("ngapp.service", [])


class Notification
  constructor: (@timeout) ->

  loading: (show = true) ->
    if show
      id = @timeout( ->
        $('.alert-box').slideDown()
      , 750)
    else
      @timeout ->
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
        $timeout( ->
          $('#all-posts time.timeago').timeago()
          $('textarea').autosize {append: "\n"}
          $('textarea').css 'resize', 'vertical'
        , 0)
    }
  ]
)
