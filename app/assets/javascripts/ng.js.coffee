
@resourcesCtrl = ($scope, $http) ->
  $http.get("/users.json").success (data) ->
    $scope.users = data

  $http.get("/posts.json").success (data) ->
    $scope.posts = data

  $scope.userLogin = (userId) ->
    elm = $('#user-'+userId)
    elm.parents('section.section').siblings().find('a').removeClass('selected')
    elm.addClass 'selected'
