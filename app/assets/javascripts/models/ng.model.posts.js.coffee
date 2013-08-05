

class Posts
  constructor: (@q, @http) ->

  load: () ->
    r = @q.defer()
    @http.get("/posts.json").success (data) ->
      for p in data
        p.replies ?= []
      r.resolve data
    @data = r.promise

  delete: (id) ->
    $http.delete("/posts/#{id}.json")
      .success (data) ->
        i = 0
        while @data[i].id != data.id
          i++
        while i < @data.length-1
          @data[i] = @data[i+1]
          i++
        @data.length -= 1


ngapp_model.factory 'posts',
  ['$q', '$http', ($q, $http)->
    new Posts $q, $http
  ]
