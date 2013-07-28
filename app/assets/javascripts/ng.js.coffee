
@ngapp = angular.module("ngapp", ["ngapp.service", "ngapp.directive", "ngapp.filter"])

$('#all-posts').on 'initialize', ->
  $('#all-posts time.timeago').timeago()
  $('textarea').autosize {append: "\n"}
  $('textarea').css 'resize', 'vertical'

