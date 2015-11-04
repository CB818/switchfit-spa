'use strict'

class BlogFeedCtrl
  constructor: ($scope, BlogFeed) ->
    $scope.items = BlogFeed.get()

BlogFeedCtrl.$inject = [ '$scope', 'BlogFeed']

angular.module('switchfitApp')
.controller 'BlogFeedCtrl', BlogFeedCtrl