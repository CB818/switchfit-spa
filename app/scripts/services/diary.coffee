'use strict'

angular.module('switchfitApp')
  .service 'Diary', (API, $resource) ->
    Diary = $resource API.path('users/:userId/diary'), {}, {}
    Diary.Picture = $resource API.path('users/:userId/diary/pictures'), {}, {
      get:
        isArray: true
    }
    Diary.Entry = $resource API.path("users/:userId/diary/entries"), {}, {
      add: {
        method: 'POST'
        transformRequest: angular.identity
        withCredentials: true
        headers:
          'Content-Type': undefined
      }

    }

    # service storage
    Diary.entries = {
      left: []
      right: []
      sideWithFirstEntry: 'right'
    }

    Diary.addEntryToSide = (entry, unshift = false) =>
      if ($(window).width() > 667)
        side = if entry.index % 2 != 0 then 'left' else 'right'
      else
        side = 'left'
      if !unshift
        if (Diary.entries.left.length == 0 && Diary.entries.right.length == 0)
          Diary.entries.sideWithFirstEntry = side
        Diary.entries[side].push(entry)
      else
        Diary.entries.sideWithFirstEntry = side
        Diary.entries[side].unshift(entry)

    Diary.getEntriesBySide = (side) =>
      switch side
        when 'left' then return Diary.entries.left
        when 'right' then return Diary.entries.right
        else return []

    Diary.pictures = []
    Diary