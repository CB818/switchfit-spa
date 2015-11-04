'use strict'

class PopoverNotificationsDay
  constructor: (@$scope, @Notifications) ->
    @$scope.isDanger = (type) =>
      switch type
        when 'day_data' then return true
        when 'day_data_front' then return true
        when 'day_timetable' then return true
        else return false

PopoverNotificationsDay.$inject = [ '$scope', 'Notifications']

angular.module('switchfitApp').controller 'PopoverNotificationsDayCtrl', PopoverNotificationsDay