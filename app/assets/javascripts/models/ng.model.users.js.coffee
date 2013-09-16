
class Users
  constructor: (@q, @http) ->

  data: {}
  loaded: false

  load: () ->
    r = @q.defer()
    users_cache = store.get 'users'
    if users_cache?
      @set_data users_cache
      @loaded = true
    @http.get("/users.json").success (data_r) =>
      @set_data data_r
      @loaded = true
      store.set 'users', data_r
      r.resolve @data
    return r.promise

  set_data: (data_to_set) ->
    delete @data[p] for p of @data
    @data[user.id.toString()] = user for user in data_to_set

ngapp_model.factory "users",
  ['$q', '$http', ($q, $http)->
    new Users $q, $http
  ]
