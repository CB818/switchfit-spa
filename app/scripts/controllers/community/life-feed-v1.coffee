'use strict'

###*
 # @ngdoc function
 # @name switchfitApp.controller:CommunityLifeFeedCtrl
 # @description
 # # CommunityLifeFeedCtrl
 # Controller of the switchfitApp
###
class CommunityLifeFeedV1Ctrl
  constructor: (@$scope, @Life, @$rootScope, @$modal, @$filter, @$stateParams) ->

    console.log @$stateParams.entryId

    @currentPage = 1
    @commentsShown = -3
    @subCommentsShown = 1

    @defaultText = ''
    @$scope.entry = {
      text: @defaultText
      emoji: ''
      photo: ''
      sfLife: 0
    }
    $scope.singleEntry = false

    if !@$stateParams.entryId
      $scope.singleEntry = false;
      if !@isPromise(@Life.entries) or !@Life.entries.length
        @Life.entries = @Life.get()
    else
      $scope.singleEntry = true;
      @Life.entries = @Life.Entry.get { entryId : @$stateParams.entryId}, {}

    @Life.entries.$promise.then () =>
      ###
        If this is a single entry the result is an Object not Array as usually
        First we make all comments expanded and then create array consisting of one entry to allow template working in loop
        as it used to.
      ###
      if (@Life.entries instanceof Array != true )
        @Life.entries.expanded = true
        for comment in @Life.entries.comments
          comment.expanded = true

        @$scope.entries = [@Life.entries];
      else
        @$scope.entries = @Life.entries
      @$scope.moreEntries = {}


      @$scope.showMoreEntries = () =>
        @currentPage += 1
        @$scope.moreEntries.areLoading = true
        @Life.moreEntries = @Life.get { page : @currentPage}
        @Life.moreEntries.$promise.then () =>
          @$scope.entries = @$scope.entries.concat(@Life.moreEntries)
          @$scope.moreEntries.areLoading = false

      ### Comments ###
      @$scope.commentsLimit = (entry) =>
        entry.expandable = Math.abs(@commentsShown) < entry.comments.length
        if entry.expanded
          return entry.comments.length
        else
          return @commentsShown

      @$scope.showAllComments = (entry) =>
        entry.expanded = true

      ### Subcomments ###
      @$scope.subCommentsLimit = (comment) =>
        if comment.children
          comment.expandable = Math.abs(@subCommentsShown) < comment.children.length

        if comment.expanded
          return comment.children.length
        else
          return @subCommentsShown

      @$scope.showAllSubComments = (comment) =>
        comment.expanded = true

      @$scope.openModal = (entry) =>
        scopeModal = @$rootScope.$new()
        scopeModal.entry = entry
        @$modal.open({
          templateUrl: 'views/modals/sfLifeModal.html'
          windowClass: 'frameless modal-md no-animation'
          controller: 'ModalLifeEntryCtrl',
          scope: scopeModal
        })

      @$scope.like = (entry) =>
        entry.isLoadingLike = true
        @Life.Like.post { entryId: entry.id }, {}, (entryResponse) =>
          entry.isLoadingLike = false
          entry.like = entryResponse.like
          entry.likeCnt = entryResponse.likeCnt

      @$scope.likeComment = (comment) =>
        comment.isLoadingLike = true
        @Life.LikeComment.post { commentId: comment.id }, {}, (commentResponse) =>
          comment.isLoadingLike = false
          comment.like = commentResponse.like
          comment.likeCnt = commentResponse.likeCnt

      @$scope.unlikeComment = (comment) =>
        comment.isLoadingLike = true
        @Life.UnlikeComment.post { commentId: comment.id }, {}, (commentResponse) =>
          comment.isLoadingLike = false
          comment.like = commentResponse.like
          comment.likeCnt = commentResponse.likeCnt

      @$scope.unlike = (entry) =>
        entry.isLoadingUnlike = true
        @Life.Unlike.post { entryId: entry.id }, {}, (entryResponse) =>
          entry.isLoadingUnlike = false
          entry.like = entryResponse.like
          entry.likeCnt = entryResponse.likeCnt

      @$scope.addComment = (entry) =>
        if (!!entry.newComment)
          entry.isLoadingComment = true
          @Life.Comment.post { entryId: entry.id }, {text: entry.newComment}, (entryResponse) =>
            @$rootScope.globalPoints.$emit('updatePoints')
            entry.isLoadingComment = false
            if @$stateParams.entryId
              for comment in entryResponse.comments
                comment.expanded = true
            entry.comments = entryResponse.comments
            entry.commentCnt = entryResponse.commentCnt
            entry.newComment = null

      @$scope.addSubComment = (entry, comment) =>
        expanded = comment.expanded
        expandable = comment.expandable
        if (!!entry['subcomment-'+comment.id])
          comment.isLoadingSubComment = true
          @Life.SubComment.post { entryId: entry.id}, {text: entry['subcomment-'+comment.id], parentComment: comment.id}, (entryResponse) =>
            @$rootScope.globalPoints.$emit('updatePoints')
            comment.isLoadingSubComment = false
            entry.commentCnt = entryResponse.commentCnt
            entry['subcomment-' + comment.id] = null
            updatedComments = @$filter('filter')(entryResponse.comments, { id : comment.id }, undefined)
            comment.expanded = expanded
            comment.expandable = expandable
            comment.children = updatedComments[0].children;

      @$scope.$on 'open_life_entry', (event, args) =>
        entry = args.entry
        @$scope.openModal(entry)

  isPromise: (obj) ->
    if angular.isObject(obj) && angular.isObject(obj.$promise) && obj.$promise.then instanceof Function && obj.$promise["catch"] instanceof Function && obj.$promise["finally"] instanceof Function
      return true
    return false

CommunityLifeFeedV1Ctrl.$inject = [ '$scope', 'Life', '$rootScope', '$modal', '$filter', '$stateParams']

angular.module('switchfitApp.community').controller 'CommunityLifeFeedV1Ctrl', CommunityLifeFeedV1Ctrl