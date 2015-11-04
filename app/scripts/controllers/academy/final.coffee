'use strict'

###*
 # @ngdoc function
 # @name switchfitApp.controller:AcademyFinalCtrl
 # @description
 # # AcademyFinalCtrl
 # Controller of the switchfitApp
###
class AcademyFinal
  constructor: (@$scope, @Academy, @$log) ->
    Academy.query().$promise.then (modules) =>
      #@$log.debug modules.reduce
      @result = modules.reduce (l, r) ->
        {score: l.score + r.score }
      ,
        { score: 0 }
      @$scope.allModules = modules

AcademyFinal.$inject = [ '$scope', 'Academy', '$log' ]

angular.module('switchfitApp')
  .controller 'AcademyFinalCtrl', AcademyFinal