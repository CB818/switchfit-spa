'use strict'

angular.module('switchfitApp')
  .service 'Notifications', (API, $resource) ->
    Notifications = $resource API.path('users/:userId/notices'), {}, {
      get:
        isArray: true
    }
    Notifications.Notice = $resource API.path("users/:userId/notices/:noticeId"), { }, {
      update: {
        method: 'PUT'
      }
    }
    Notifications.notices = []
    Notifications.dayNotices = {}
    Notifications
