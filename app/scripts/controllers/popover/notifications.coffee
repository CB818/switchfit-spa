'use strict'

class PopoverNotifications
  constructor: (@$scope, @Notifications, @User, @$rootScope, @$modal, @$location, @$timeout, @$filter) ->
    @$rootScope.currentUser.$promise.then =>
      @currentUser = @$rootScope.currentUser
      @init()
    @$scope.showPopover = true

  init: =>
    notices = @Notifications.get { userId: @currentUser.id, status: 'new' }
    notices.$promise.then (notices) =>
      @Notifications.notices = notices
      @$scope.notices = @Notifications.notices
      # highlighting notice item in menu
      if @Notifications.notices.length > 0
        @$scope.$parent.hasNotice = true

    @$scope.isDangerModal = (type) =>
      switch type
        when 'week_data' then return true
        else return false

    @$scope.isDangerLink = (type) =>
      switch type
        when 'day_data' then return true
        when 'day_timetable' then return true
        else return false

    @$scope.isDangerText = (type) =>
      switch type
        when 'start_day' then return true
        when 'day_3' then return true
        when 'day_6' then return true
        when 'every_monday' then return true
        when 'every_saturday' then return true
        when 'default' then return true
        else return false

    @$scope.isFaqAnswer = (type) =>
      switch type
        when 'faq_answer' then return true
        else return false

    @$scope.openModal = (notice) =>
      switch notice.type
        when 'week_data' then @openWeekDataModal(notice)
        else return false

    @$scope.linkTo = (notice) =>
      switch notice.type
        when 'day_data' then @linkTo(notice)
        when 'day_timetable' then @linkTo(notice)
        else return false

    @$scope.$on 'notification_popover.close', () =>
      if @Notifications.notices.length > 0
        for notice, i in @Notifications.notices
          @Notifications.Notice.update  { userId: @currentUser.id, noticeId: notice.id }, {}, (data) =>
            @Notifications.notices.splice(_.findIndex(@Notifications.notices, {id: data.id}), 1);
            if @Notifications.notices.length == 0
              @$scope.$parent.hasNotice = false

  openWeekDataModal: (notice) =>
    if notice.extData.weekYearNumber?
      scopeModal = @$rootScope.$new()
      scopeModal.week = notice.extData.weekYearNumber
      scopeModal.notice = notice
      modalInstance = @$modal.open({
        templateUrl: 'views/modals/weekly-data.html'
        windowClass: 'modal-md'
        controller: 'ModalWeeklyDataCtrl',
        scope: scopeModal
      })

  linkTo: (notice) =>
    dayDate = moment()
    @$location.path("/").search({dayHighlight: dayDate.format('L')})

PopoverNotifications.$inject = [ '$scope', 'Notifications', 'User', '$rootScope', '$modal', '$location', '$timeout', '$filter']

angular.module('switchfitApp').controller 'PopoverNotificationsCtrl', PopoverNotifications
