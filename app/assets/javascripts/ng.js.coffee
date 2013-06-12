
@resourcesCtrl = ['$scope', '$http', '$timeout', ($scope, $http, $timeout) ->
  token = $("meta[name='csrf-token']").attr("content")
  $http.defaults.headers.common["X-CSRF-Token"] = token

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
    $timeout -> $('#all-posts').trigger 'initialize'

  $scope.userLogin = (userId) ->
    $http.post('/login.json', {name: $scope.users[userId].name})
      .success (data) ->
        return unless data.id == userId

        $scope.loggedInUser = data
        elm = $('#user-'+userId)
        elm.parents('section.section').siblings().find('a').removeClass('selected')
        elm.addClass 'selected'

  $scope.$watch 'loggedInUser.id', (val) ->
    $('#post-panel').removeClass('hide') if val?

  $scope.postSubmit = ->
    $http.post('/posts.json', {msg: $scope.postMessage})
      .success (data) ->
        unless data.user_id != $scope.loggedInUser.id
          $scope.posts.unshift data
          $scope.postMessage = ''
          $('textarea').height 0

  $scope.properTime = (time) ->
    time = time.slice time.indexOf('T')+1, time.indexOf('+')
]

$('textarea').autosize({append: "\n"});
$('#all-posts').on 'initialize', ->
  $('#all-posts time.timeago').timeago()

