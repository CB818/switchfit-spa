'use strict'
angular.module('switchfitApp.quests', ['ui.router'])
.config ($stateProvider) ->
  $stateProvider
  .state 'qod',
    url: '/quests/current',
    templateUrl: 'views/quests/quest.html'
    controller: 'QodCtrl as quest'
  .state 'qods-overview',
    url: '/quests',
    templateUrl: 'views/quests/quests-overview.html'
    controller: 'QodsOverviewCtrl'
  .state 'qod-overview',
    url: '/quests/{questId:[0-9]{1,2}}',
    templateUrl: 'views/quests/quest.html'
    controller: 'QodCtrl as quest'

class QodModal
  constructor: (@$scope, @$modalInstance, @QodData, @$rootScope) ->
    @$scope.dismissQuest = () =>
      @$modalInstance.dismiss()
    @$scope.completeQuest = (quest) =>
      @QodData.Complete.post { questId : quest.id}, {}, (questResponse) =>
        @$rootScope.globalPoints.$emit('updatePoints')
        @$rootScope.questsUpdater.$emit('questUpdated', questResponse)
        @$modalInstance.close()
        window.Intercom('trackEvent','quest-complete-' + quest.id)
        undefined

QodModal.$inject = ['$scope', '$modalInstance', 'QodData', '$rootScope']
angular.module('switchfitApp').controller 'QodModalCtrl', QodModal

class Qod
  constructor: (@$scope, @QodData, @$rootScope, @$stateParams, @$state, @$modal) ->
    if $stateParams.questId
      @quests = @QodData.QuestById.get({questId : $stateParams.questId})
    else
      @quests = @QodData.get()

    questsUpdater = @$rootScope.$new()
    @$rootScope.questsUpdater = questsUpdater

    questsUpdater.$on 'questUpdated', (scope, quest) =>
        @$scope.quest = quest
        undefined

    @quests.$promise.then (result)  =>
      if result
        @$scope.quest = result

        @$scope.assignQuest = (quest) =>
          @QodData.Assign.post { questId : quest.id}, {}, (questResponse) =>
            @$scope.quest = questResponse
            @$state.go 'qods-overview'
            window.Intercom('trackEvent','quest-start-' + quest.id)


        @$scope.openConfirmPopup = () =>
          @$modal.open({
            templateUrl: 'views/quests/confirmComplete.html',
            windowClass: 'modal-sm fade in',
            controller : 'QodModalCtrl',
            scope : @$scope
          });

    , (err) =>
      if err.status == 470
        @$scope.limitExceeded = true




Qod.$inject = [ '$scope', 'QodData', '$rootScope', '$stateParams', '$state', '$modal']

angular.module('switchfitApp.quests')
.controller 'QodCtrl', Qod