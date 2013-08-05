
class Users
  constructor: (@q, @http) ->

  load: () ->
    r = @q.defer()
    @http.get("/users.json").success (data) ->
      result = {}
      for user in data
        result[user.id.toString()] = user
      r.resolve result
    @data = r.promise

ngapp_model.factory "users",
  ['$q', '$http', ($q, $http)->
    new Users $q, $http
  ]
