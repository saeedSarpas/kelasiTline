
ngapp.controller "resourcesCtrl",
    ['$scope', '$http', '$q', '$timeout', 'notification', 'utilities', 'users', 'posts',
    ($scope, $http, $q, $timeout, notification, utilities, users, posts) ->
      notification.loading on

      $scope.replyMsg = {}

      $q.all(
        $scope.users = users.load(),
        $scope.posts = posts.load()
      ).then ->
        utilities.initialization()
        notification.loading off

      $scope.postSubmit = ->
        notification.loading on
        $http.post('/posts.json', {msg: $scope.postMessage})
          .success (data) ->
            unless data.user_id != $scope.loggedInUser.id
              data.replies ?= []
              $q.when($scope.posts).then (p) -> p.unshift data
              $scope.postMessage = ''
              $('textarea').height 0
              utilities.initialization()
              notification.loading off

      $scope.replyClick = (id) ->
        notification.loading on
        rep = $('#reply-'+id)
        msg = rep.val()
        rep.val ''
        $http.post('/posts.json', {msg: msg, parent_id: id})
          .success (data) ->
            for p in $scope.posts
              if p.id == data.parent_id
                p.replies.unshift data
            utilities.initialization()
            notification.loading off

      $scope.deletePost = (id) ->
        notification.loading on
        $http.delete("/posts/#{id}.json")
          .success (data) ->
            id = "#post-#{data.id}"
            $(id).slideUp()
            notification.loading off

      $scope.showDelete = (id, show) ->
        item = $("#post-#{id} > .row > .columns > .delete-button")
        if show
          item.show()
        else
          item.hide()

      $scope.showReply = (id) ->
        $("#post-#{id} .reply-placeholder").hide()
        $("#post-#{id} .reply-box").show()

      $scope.properTime = (time) ->
        if time?
          time = time.slice time.indexOf('T')+1, time.indexOf('+')
        else ""
    ]

ngapp.controller "commandCntl",
  [ '$scope', '$rootScope', '$http', '$q', 'users', ($scope, $rootScope, $http, $q, users) ->
    $scope.placeholder = "Try typing 'Login <Your Name>'"
    $scope.runCommand = ->
      cmd = $scope.command.split ' '
      if cmd[0] == 'login'
        $q.when(users.data).then (users) ->
          user = (users[u] for u of users when users[u].name == cmd[1])
          if user.length == 1
            user = user[0]
          else
            console.log 'Error', user, users, cmd
            return
          $http.post('/login.json', user)
            .success (data) ->
              return unless data.id == user.id

              $rootScope.loggedInUser = user
      if cmd[0] == 'logout'
        $http.get('/logout').success -> $rootScope.loggedInUser = null
  ]
