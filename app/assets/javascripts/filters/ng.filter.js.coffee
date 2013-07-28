

ngapp_filter = angular.module("ngapp.filter", [])


ngapp_filter.filter("reverse", ->
    (arr) ->
      arr.slice().reverse()
  )
