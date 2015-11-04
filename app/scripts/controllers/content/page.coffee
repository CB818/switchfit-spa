'use strict'

class ContentPage
  constructor: (@$scope, $state, Content, @$sce) ->
    slug = $state.current.name.split('.').pop()
    content = Content.Page.get { slug: slug }
    content.$promise.then (data) =>
      @$scope.contentPage = @$sce.trustAsHtml(data.content)

ContentPage.$inject = [ '$scope', '$state', 'Content', '$sce' ]

angular.module('switchfitApp')
  .controller 'ContentPageCtrl', ContentPage
