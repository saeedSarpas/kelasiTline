

ngapp_service = angular.module("ngapp.service", [])


class Notification
  constructor: (@timeout) ->

  timeoutId: null
  loading: (show = true) ->
    @timeout.cancel @timeoutId
    if show
      id = @timeout ->
        console.log 'hi'
      @timeoutId = id
      $('.alert-box').slideDown()
      # , 0)
    else
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
      loadUsers: ->
        r = $q.defer()
        $http.get("/users.json").success (data) ->
          result = {}
          for user in data
            result[user.id.toString()] = user
          r.resolve result
        return r.promise
      loadPosts: ->
        r = $q.defer()
        $http.get("/posts.json").success (data) ->
          for p in data
            p.replies ?= []
          r.resolve data
        return r.promise
    }
  ]
)
