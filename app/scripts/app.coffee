'use strict'

angular
  .module('switchfitApp', [
    'ngCookies',
    'ngResource',
    'ngSanitize',
    'ui.router',
    'ui.bootstrap',
    'ui.validate',
    'perfect_scrollbar',
    'nya.bootstrap.select',
    'angularFileUpload',
    'angularMoment',
    'angularSpinner',
    'videosharing-embed',
    'pascalprecht.translate',
    'ngDragDrop',
    'switchfitApp.dashboard'
    'switchfitApp.kitchen'
    'switchfitApp.gym'
    'switchfitApp.academy'
    'switchfitApp.community'
    'switchfitApp.statistics'
    'switchfitApp.qa'
    'switchfitApp.login'
    'switchfitApp.settings'
    'switchfitApp.diary'
    'switchfitApp.resetting'
    'switchfitApp.quests'
    'switchfitApp.points'
    'bootstrapLightbox'
  ])
#  .run ($amMoment) ->
#    $amMoment.changeLocale('de');
  .config ($stateProvider, $locationProvider, $urlRouterProvider, $translateProvider) ->
    $stateProvider
      .state 'access-denied',
        url: '/access-denied',
        templateUrl: 'views/access-denied.html'
        controller: 'MainCtrl'
      .state 'terms',
        url: '/terms-and-conditions',
        templateUrl: 'views/terms-and-conditions.html'
        controller: 'MainCtrl'
      .state 'demo.terms',
        url: '/terms-and-conditions',
        templateUrl: 'views/terms-and-conditions.html'
        controller: 'MainCtrl'

    $urlRouterProvider.otherwise '/'
    
    $locationProvider.html5Mode(true).hashPrefix('!')
    $translateProvider.preferredLanguage('de')
    $translateProvider.useLoader '$translateSwitchfitLoader', {
      prefix: '/api/v1/frontend/translations/',
      suffix: '.json',
      domain: 'NordcodeSwitchfitBundle'
    }

  .config (LightboxProvider) ->
    LightboxProvider.templateUrl = 'views/modals/lightbox.html';
