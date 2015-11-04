'use strict'

class ModalManifesto
  constructor: (@$scope, @$rootScope, @Course, @$timeout) ->
    @$rootScope.currentUser.$promise.then =>
      @$scope.signature = @$rootScope.userCourse.signatureOfManifesto
      @$scope.isLoading = false

      @$scope.addSignature = () =>
        if @$scope.signaturePadApi isnt undefined
          @addSig(@$scope.signaturePadApi.getSignatureImage())
  addSig: (sig) =>
    @$scope.isLoading = true
    @Course.Signature.sig {userId: @$rootScope.currentUser.id, courseId: @$rootScope.userCourse.id}, {signature: sig}, (data) =>
      @$scope.successfullyAdded = true
      @$timeout(=>
        @$scope.successfullyAdded = false
        return
      , 3000
      )
      @$scope.isLoading = false
      @$rootScope.userCourse.signatureOfManifesto = data.signatureOfManifesto
      @$scope.signature = @$rootScope.userCourse.signatureOfManifesto
      @$scope.$close();
      return
    , (data) =>
      if data.data && data.data.errors && data.data.errors.children
        for field, error of data.data.errors.children
          if error.errors
            for err in error.errors
              if !@$scope.errorsFields[field]?
                @$scope.errorsFields[field] = []
              @$scope.errorsFields[field].push(err)

      if @$scope.errors.length == 0
        @$scope.errors.push('Something wrong!')
      @$scope.reset()
      @$scope.isLoading = false

ModalManifesto.$inject = [ '$scope', '$rootScope', 'Course', '$timeout']

angular.module('switchfitApp.diary')
  .controller 'ModalManifestoCtrl', ModalManifesto
