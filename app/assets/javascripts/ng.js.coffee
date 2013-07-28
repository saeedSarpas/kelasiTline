
@ngapp = angular.module("ngapp", ["ngapp.service", "ngapp.directive", "ngapp.filter"],
  ['$routeProvider', '$locationProvider', '$httpProvider', ($routeProvider, $locationProvider, $httpProvider) ->
    token = $("meta[name='csrf-token']").attr("content")
    $httpProvider.defaults.headers.common["X-CSRF-Token"] = token
    $httpProvider.defaults.headers.common["X-From-Angular"] = 'True'

    $routeProvider.when '/home',
      templateUrl: 'home'
      controller: 'resourcesCtrl'

    $locationProvider.html5Mode on
  ]).run ['$location', ($location) ->
    $location.path '/home'
  ]

