#= require jquery
#= require bootstrap
#= require angular
#= require 'services/timeline.service'
#= require 'directives/timeline.directive'
#= require 'jquery.mousewheel'
#= require 'perfect-scrollbar'

timelineModule = angular.module("timelineModule",["timeline.service", "timeline.directive"]);
