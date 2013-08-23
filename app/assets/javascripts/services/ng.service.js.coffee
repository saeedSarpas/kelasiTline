

ngapp_service = angular.module("ngapp.service", [])


class Command
  constructor: (@http, @q, @posts) ->

  run: (commandd, parameter) ->
    switch commandd 
      when "post"
        msg = parameter
        return if msg == ''

        @http.post('/posts.json', {msg: parameter})
          .success (data) =>
            data.replies ?= []
            @posts.data.unshift data
      else
        console.log("command not found")
    

ngapp_service.factory("command", 
  ['$http', '$q', 'posts', ($http, $q, posts) ->
    new Command $http, $q, posts
  ]
)


class Notification
  constructor: (@timeout, @q) ->

  timeoutId: null
  jobs: []

  clean: ->
    @timeout.cancel @timeoutId if @timeoutId?
    @timeoutId = null
    $('.alert-box').slideUp()

  check: ->
    if (0 for j in @jobs when j.done).length
      @jobs = []
      @clean()

  loading: (promise) ->
    @timeoutId = @timeout( (-> $('.alert-box').slideDown()) , 750)

    @jobs.push job = done: no
    promise.then =>
      job.done = yes
      promise


ngapp_service.factory("notification",
  ['$timeout', '$q', ($timeout, $q) ->
    new Notification $timeout, $q
  ]
)

ngapp_service.factory("utilities", 
  [ '$timeout', '$http', '$q', 'notification'
  ($timeout, $http, $q, notification) ->
    return {
      initialization: ->
        $('#all-posts time.timeago').timeago()
        $('textarea').autosize( append: "\n" )
          .css 'resize', 'vertical'
        notification.check()
    }
  ]
)
