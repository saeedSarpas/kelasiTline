angular.module("timeline.directive",[])
  .directive("sidebar", ->
  	{
  	  restrict: 'E'
  	  template:
  	  	'<div class="sidebar">
  	  		<div class="scrollbar-x"></div>
  	  		<div class="scrollbar-y"></div>
  	  		<div ng-transclude></div>
  	  	</div>'
  	  replace: true
  	  scope: false
  	  transclude: true
  	  link: (scope, element, attr) ->
  	  	$(element).perfectScrollbar();
  	})