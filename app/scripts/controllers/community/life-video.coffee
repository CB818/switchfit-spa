'use strict'

class ModalLifeVideo
  constructor: (@$scope) ->

ModalLifeVideo.$inject = [ '$scope' ]

angular.module('switchfitApp.community')
  .controller 'ModalLifeVideoCtrl', ModalLifeVideo
