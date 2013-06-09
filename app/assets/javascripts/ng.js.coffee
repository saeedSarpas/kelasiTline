
@userController = ($scope, $http) ->
  $http.get("/users.json").success (data) ->
    $scope.users = data

@postsController = ($scope, $http) ->
  $http.get("/posts.json").success (data) ->
    $scope.posts = data
