'use strict'
angular.module('switchfitApp.kitchen', ['ui.router'])
.config ($stateProvider) ->
  $stateProvider
    .state 'kitchen',
      url: '/kitchen',
      templateUrl: 'views/kitchen.html'
      controller: 'MealsCtrl as meals'
    .state 'kitchen.basic-meals',
      url: '/basic-meals',
      templateUrl: 'views/kitchen/basic-meals.html'
      controller: 'ContentPageCtrl'
    .state 'kitchen.about',
      url: '/about',
      templateUrl: 'views/kitchen/about.html'
      controller: 'ContentPageCtrl'
    .state 'kitchen.detox',
      url: '/detox',
      templateUrl: 'views/kitchen/detox.html'
      controller: 'ContentPageCtrl'
    .state 'kitchen.recipe',
      url: '/:recipe',
      templateUrl: 'views/kitchen/recipe.html'
      controller: 'MealsRecipeCtrl as recipe'
    .state 'demo.kitchen',
      url: '/kitchen',
      templateUrl: 'views/demo/kitchen.html'
      controller: 'DemoMealsCtrl as meals'
    .state 'demo.kitchen.recipe',
      url: '/:recipe',
      templateUrl: 'views/demo/recipe.html'
      controller: 'DemoMealsRecipeCtrl as recipe'

class Meals
  constructor: (@$scope, @$log, @Meals, @$rootScope, @$timeout, @$translate, @$filter, @$cookieStore, @usSpinnerService) ->
    @mealsShown = 1
    @mealsSize = 25
    @types = []
    @categories = []
    @typesMap = {}
    @$scope.isLoading = true
    @defaultFiltersKitchen = {
      type: 0
      categoriesMap: {}
      favs: false
      products: []
    }
    @filtersKitchen = @$cookieStore.get('switchfit_filters_kitchen')
    if @filtersKitchen
      @filtersKitchen = _.assign(angular.copy(@defaultFiltersKitchen), @filtersKitchen)
    else
      @filtersKitchen = angular.copy(@defaultFiltersKitchen)
    @onlyFavs = @filtersKitchen.favs

    @$rootScope.currentUser.$promise.then =>
      if !@isPromise(@Meals.allFilters)
        @Meals.allFilters = @Meals.filters()
      @Meals.allFilters.$promise.then (filters) =>
        @filters = filters
        @products = angular.copy(filters.products)
        @$scope.productsRange = _.range(1, Math.ceil(@products.length/2)+1)
        @products.forEach (product) =>
          if @filtersKitchen.products.length == 0
            product.checked = true
          else
            if product.id in @filtersKitchen.products
              product.checked = true
            else
              product.checked = false
        @types = [ { id: 0, title: 'Alle Typen' } ].concat(filters.types)
        for t in filters.types
          @typesMap[t.slug] = t.id
        @type = @filtersKitchen.type

        if !@isPromise(@Meals.allCategories)
          @Meals.allCategories = @Meals.categories()
        @Meals.allCategories.$promise.then (categories) =>
          @categories = categories
          if @types?
            subCategories = @types.filter((type) => type.id == @type)[0]?.categories
            @categories = [ { id: 0, title: 'Alle Kategorien' } ]

            if subCategories isnt undefined
              @categories = @categories.concat(subCategories)
          if @filtersKitchen.categoriesMap[@type] isnt undefined
            for cat in @categories
              if cat.id == @filtersKitchen.categoriesMap[@type]
                @category = @filtersKitchen.categoriesMap[@type]
                break
              else
                @category = 0
          else
            @category = 0

        if !@isPromise(@Meals.allMeals)
          @Meals.allMeals = @Meals.query()
        @Meals.allMeals.$promise.then (meals) =>
          @$scope.allMeals = meals
          @$scope.isLoading = false
          @usSpinnerService.stop('kitchen-loader')

    window.Intercom('trackEvent', 'page-visit-kitchen')

  filterCategories: =>
    if @type == 0
      @category = 0
      return @categories

    if @types?
      subCategories = @types.filter((type) => type.id == @type)[0]?.categories
      @categories = [ { id: 0, title: 'Alle Kategorien' } ]

      if subCategories isnt undefined
        @categories = @categories.concat(subCategories)

    if @filtersKitchen.categoriesMap[@type] isnt undefined
      for cat in @categories
        if cat.id == @filtersKitchen.categoriesMap[@type]
          @category = @filtersKitchen.categoriesMap[@type]
          break
        else
          @category = 0
    else
      @category = 0
    @filtersKitchen.type = @type
    @$cookieStore.put('switchfit_filters_kitchen', @filtersKitchen)

    return @categories

  changeCategory: =>
    slug = @types.filter((type) => type.id == @type)[0]?.slug
    if slug == 'meal_a' or slug == 'meal_b'
      @filtersKitchen.categoriesMap[@typesMap['meal_a']] = @category
      @filtersKitchen.categoriesMap[@typesMap['meal_b']] = @category
    else
      @filtersKitchen.categoriesMap[@type] = @category
    @$cookieStore.put('switchfit_filters_kitchen', @filtersKitchen)

  changeProducts: =>
    @filtersKitchen.products = []
    for product in @products
      if product.checked
        @filtersKitchen.products.push product.id
    @$cookieStore.put('switchfit_filters_kitchen', @filtersKitchen)

  changeFavs: (state) =>
    @onlyFavs = state
    @filtersKitchen.favs = @onlyFavs
    @$cookieStore.put('switchfit_filters_kitchen', @filtersKitchen)

  filteredMeals: =>
    if @$scope.allMeals?
      orderBy = @$filter('orderBy')
      meals = orderBy @$scope.allMeals, 'sort'

      if @type != 0
        meals = meals.filter (meal) =>
          inTypes = meal.type.filter (type) =>
            type.id == @type
          if inTypes.length > 0
            true
          else
            false

      if @category != 0
        meals = meals.filter (meal) =>
          inCategories = meal.category.filter (category) =>
            category.id == @category
          if inCategories.length > 0
            true
          else
            false

      if @onlyFavs
        meals = meals.filter (meal) -> meal.favorite == true

      if @products?
        excludedProducts = @products.filter (product) -> !product.checked
        if excludedProducts.length > 0
          excludedProductsIds = excludedProducts.map (product) -> product.id
          meals = meals.filter (meal) =>
            if meal.product.length == 0
              return true
            inExcludedProducts = meal.product.filter (product) -> product.id in excludedProductsIds
            if inExcludedProducts.length > 0
              false
            else
              true
      else
        meals = meals.filter (meal) =>
          if meal.product.length == 0
            true
          else
            false
      @currentFilteredMealsLength = meals.length
      meals

  getPreview: (meal) =>
    for media in meal.media
#      if media.type == 'photo'
      return media

  resetFilters: =>
    @onlyFavs = false

    # type select fix
    @$timeout () =>
      angular.element('.bootstrap-select.type-select .selectpicker [rel="0"] a[tabindex="0"]').click()
      @type = 0

    # category select fix
    @$timeout () =>
      angular.element('.bootstrap-select.category-select .selectpicker [rel="0"] a[tabindex="0"]').click()
      @category = 0

    @products.forEach (product) =>
        product.checked = true

    @categories = []
    @$cookieStore.put('switchfit_filters_kitchen', @defaultFiltersKitchen)
    return

  mealsLimit: =>
    return @mealsSize * @mealsShown

  showingMealsLength: =>
    if @currentFilteredMealsLength > @mealsSize * @mealsShown
      return @mealsSize * @mealsShown
    else
      return @currentFilteredMealsLength

  hasMoreMealsToShow: =>
    filteredMeals = @filteredMeals()
    if filteredMeals is undefined
      return false

    return @mealsShown < (@filteredMeals().length / @mealsSize)

  showMoreMeals: ->
    @mealsShown = @mealsShown + 1

  isPromise: (obj) ->
    if angular.isObject(obj) &&
      angular.isObject(obj.$promise) &&
      obj.$promise.then instanceof Function &&
      obj.$promise["catch"] instanceof Function &&
      obj.$promise["finally"] instanceof Function
        return true
    return false

Meals.$inject = [ '$scope', '$log', 'Meals', '$rootScope', '$timeout', '$translate', '$filter', '$cookieStore', 'usSpinnerService' ]

angular.module('switchfitApp.kitchen')
  .controller 'MealsCtrl', Meals


class DemoMeals extends Meals

DemoMeals.$inject = [ '$scope', '$log', 'DemoMeals', '$rootScope', '$timeout', '$filter', '$cookieStore', 'usSpinnerService' ]

angular.module('switchfitApp.kitchen')
  .controller 'DemoMealsCtrl', DemoMeals
