

ngapp.controller "resourcesCtrl",
    ['$scope', '$http', '$timeout', 'notification', 'utilities', ($scope, $http, $timeout, notification, utilities) ->
      notification.loading on

      token = $("meta[name='csrf-token']").attr("content")
      $http.defaults.headers.common["X-CSRF-Token"] = token
      $http.defaults.headers.common["X-From-Angular"] = 'True'

      $scope.replyMsg = {}

      $scope.loggedInUser =
        picture: 'assets/user.png'
        notifications: 0

      $http.get("/users.json").success (data) ->
        $scope.users = {}
        for user in data
          $scope.users[user.id.toString()] = user
          $scope.users[user.id.toString()].notifications = 0

      $http.get("/posts.json").success (data) ->
        for p in data
          p.replies ?= []
        $scope.posts = data
        utilities.initialization()
        notification.loading off

      $scope.userLogin = (userId) ->
        notification.loading on
        $http.post('/login.json', {name: $scope.users[userId].name})
          .success (data) ->
            return unless data.id == userId

            $scope.loggedInUser = data
            elm = $('#user-'+userId)
            elm.parents('section.section').siblings().find('a').removeClass('selected')
            elm.addClass 'selected'
            notification.loading off

      $scope.postSubmit = ->
        notification.loading on
        $http.post('/posts.json', {msg: $scope.postMessage})
          .success (data) ->
            unless data.user_id != $scope.loggedInUser.id
              data.replies ?= []
              $scope.posts.unshift data
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
