
@resourcesCtrl = ['$scope', '$http', ($scope, $http) ->
  $scope.loggedInUser =
    picture: 'assets/user.png'
    notifications: 0

  $http.get("/users.json").success (data) ->
    $scope.users = {}
    for user in data
      $scope.users[user.id.toString()] = user
      $scope.users[user.id.toString()].notifications = 0

  $http.get("/posts.json").success (data) ->
    $scope.posts = data

  $scope.userLogin = (userId) ->
    $scope.loggedInUserId = userId
    elm = $('#user-'+userId)
    elm.parents('section.section').siblings().find('a').removeClass('selected')
    elm.addClass 'selected'

  $scope.$watch 'loggedInUserId', ->
    $scope.loggedInUser = $scope.users[$scope.loggedInUserId]
]
