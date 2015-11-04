'use strict'

class ModalLifeEntry
  constructor: (@$scope, @Life, @$filter, @$rootScope) ->
    @Life.Entry.get { entryId: @$scope.entry.id }, (entry) =>
      @$scope.entry = entry
    @$scope.lifeComment = null
    @$scope.isLoadingLike = false
    @$scope.isLoadingComment = false

    @$scope.like = () =>
      @$scope.isLoadingLike = true
      @Life.Like.post { entryId: @$scope.entry.id }, {}, (entry) =>
        @$scope.isLoadingLike = false
        @$scope.entry.like = entry.like
        @$scope.entry.likeCnt = entry.likeCnt

        entryInList = @Life.entries.filter (entryList) =>
          entryList.id == entry.id
        if entryInList.length > 0
          entryInList[0].likeCnt = entry.likeCnt

    @$scope.addComment = () =>
      @$scope.isLoadingComment = true
      @Life.Comment.post { entryId: @$scope.entry.id }, {text: @$scope.lifeComment}, (entry) =>
        @$scope.isLoadingComment = false
        @$scope.entry.comments = entry.comments
        @$scope.entry.commentCnt = entry.commentCnt
        @$scope.lifeComment = null
        entryInList = @Life.entries.filter (entryList) =>
          entryList.id == entry.id
        if entryInList.length > 0
          entryInList[0].commentCnt = entry.commentCnt
#        console.log(entryInList)

    @$scope.prev = (entry) =>
      orderBy = @$filter('orderBy')
      entries = orderBy @Life.entries, '-createdAt'
      index = -1
      for value,i in entries
        if value.id == entry.id
          index = i
      if index > 0 and index < entries.length - 1
        prevEntry = entries[index - 1]
      else if index <= 0
        prevEntry = entries[entries.length - 1]
      @$scope.$close()
      if prevEntry
        @$rootScope.$broadcast('open_life_entry', { entry: prevEntry })

    @$scope.next = (entry) =>
      orderBy = @$filter('orderBy')
      entries = orderBy @Life.entries, '-createdAt'
      index = -1
      for value,i in entries
        if value.id == entry.id
          index = i
      if index >= 0 and index < entries.length - 1
        nextEntry = entries[index + 1]
      else if index == entries.length - 1
        nextEntry = entries[0]
      @$scope.$close()
      if nextEntry
        @$rootScope.$broadcast('open_life_entry', { entry: nextEntry })


ModalLifeEntry.$inject = [ '$scope', 'Life', '$filter', '$rootScope']

angular.module('switchfitApp.community')
  .controller 'ModalLifeEntryCtrl', ModalLifeEntry
