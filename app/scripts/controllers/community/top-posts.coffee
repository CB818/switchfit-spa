'use strict'

class TopPostsCtrl
  constructor: ($scope, TopPosts) ->
    $scope.items = TopPosts.get()

TopPostsCtrl.$inject = [ '$scope', 'TopPosts']

angular.module('switchfitApp')
.controller 'TopPostsCtrl', TopPostsCtrl