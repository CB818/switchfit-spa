'use strict'

###*
 # @ngdoc service
 # @name switchfitApp.life
 # @description
 # # Qod / Quest of the day
 # Service in the switchfitApp.
###
angular.module('switchfitApp')
.service 'QodData', (API, $resource) ->
  QodData = $resource API.path('quest/current'), {}, {
    get:
      method: 'GET'
  }
  QodData.Assign = $resource API.path('quests/:questId/starts'), {}, {
    post:
      method: 'POST'
  }
  QodData.Complete = $resource API.path('quests/:questId/completes'), {}, {
    post:
      method: 'POST'
  }
  QodData.AllPreviousQuests = $resource API.path('quests/'), {}, {
    get:
      method  : 'GET',
      isArray : true
  }
  QodData.QuestById = $resource API.path('quests/:questId'), {}, {
    get:
      method  : 'GET'
  }
  QodData

