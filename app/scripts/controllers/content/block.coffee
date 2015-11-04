'use strict'

class ContentBlock
  constructor: (@$scope, @Content, @$sce) ->
  init: (slug) =>
    content = @Content.Block.get { slug: slug }, {}, =>
    content.$promise.then (data) =>
      @contentBlock = @$sce.trustAsHtml(data.content)

ContentBlock.$inject = [ '$scope', 'Content', '$sce' ]

angular.module('switchfitApp')
  .controller 'ContentBlockCtrl', ContentBlock
