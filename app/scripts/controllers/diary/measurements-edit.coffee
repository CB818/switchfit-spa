'use strict'

###*
 # @ngdoc function
 # @name switchfitApp.controller:WeightModalsCtrl
 # @description
 # # VideoModalsCtrl
 # Controller of the switchfitApp
###
class MeasurementsModals
  constructor: (@$scope, @Course, @User, @$rootScope, @$modalInstance) ->
    @$scope.Math = window.Math
    @$scope.data = {
      chest: if @$rootScope.currentUser.activeUserCourse.measurementChest then @$rootScope.currentUser.activeUserCourse.measurementChest else 0,
      waist: if @$rootScope.currentUser.activeUserCourse.measurementWaist then @$rootScope.currentUser.activeUserCourse.measurementWaist else 0,
      hips : if @$rootScope.currentUser.activeUserCourse.measurementHips then @$rootScope.currentUser.activeUserCourse.measurementHips else 0,
      measurements : @$rootScope.currentUser.activeUserCourse.measurementTotal
    }

    @$rootScope.currentUser.$promise.then =>
      @currentUser = @$rootScope.currentUser
      @userData = @currentUser.activeUserCourse
      console.log(@userData);
      ### Setting initials ###
      @$scope.user_id = @currentUser.id
      @$scope.course_id = @userData.id

      undefined


    @$scope.updateMeasurements = () =>
      @$scope.data.measurements = parseInt(@$scope.data.chest) + parseInt(@$scope.data.waist) + parseInt(@$scope.data.hips)
      if @$scope.data.measurements > 0
        @User.Measurements.post { userId: @$scope.user_id, courseId: @$scope.course_id}, {measurement_chest : @$scope.data.chest, measurement_waist : @$scope.data.waist, measurement_hips : @$scope.data.hips }, (response) =>
          @$rootScope.userCourse.measurementTotal = response.measurementTotal
          @$modalInstance.close()
          @$rootScope.globalPoints.$emit('updatePoints')
          location.reload();
          undefined

      undefined

MeasurementsModals.$inject = [ '$scope', 'Course', 'User', '$rootScope', '$modalInstance']

angular.module('switchfitApp').controller 'MeasurementsModalsCtrl', MeasurementsModals
