

ngapp_service = angular.module("ngapp.service", [])


ngapp_service.factory("notification",
  ['$timeout', ($timeout) ->
    return {
      loading: (show = true) ->
        $timeout.cancel @timeout
        if show
          @timeout = $timeout (-> $('.alert-box').slideDown()), 0
        else
          $('.alert-box').slideUp()
    }
  ]
)

ngapp_service.factory("utilities", 
  [ '$timeout', ($timeout) ->
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
