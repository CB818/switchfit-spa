'use strict'

###*
 # @ngdoc function
 # @name switchfitApp.controller:WeightModalsCtrl
 # @description
 # # VideoModalsCtrl
 # Controller of the switchfitApp
###
class WeightModals
  constructor: (@$scope, @Course, @User, @$rootScope, @$modalInstance, @$state) ->
    @$scope.Math = window.Math
    @$scope.data = {
      change : {
        positive : true
      },
      currentWeight : 0,
      actualWeight : 0,
      goalWeight : 0,
      delta1 : 0,
    }

    @$rootScope.currentUser.$promise.then =>
      @currentUser = @$rootScope.currentUser
      @userData = @currentUser.activeUserCourse
      ### Setting initials ###
      @$scope.user_id = @currentUser.id
      @$scope.course_id = @userData.id
      @$scope.data.actualWeight = @userData.currentWeight

      undefined


    @$scope.updateWeight = () =>
      if @$scope.data.actualWeight
        @User.Weight.post { userId: @$scope.user_id, courseId: @$scope.course_id}, {current_weight : @$scope.data.actualWeight }, (response) =>
          @$rootScope.userCourse.currentWeight = response.currentWeight
          @$modalInstance.close()
          @$rootScope.globalPoints.$emit('updatePoints')
          location.reload();
          undefined

      undefined

WeightModals.$inject = [ '$scope', 'Course', 'User', '$rootScope', '$modalInstance', '$state']

angular.module('switchfitApp').controller 'WeightModalsCtrl', WeightModals
