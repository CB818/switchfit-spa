'use strict'

###*
 # @ngdoc function
 # @name switchfitApp.controller:ModalFoodModalCtrl
 # @description
 # # ModalFoodModalCtrl
 # Controller of the switchfitApp
###
class FoodModal
  constructor: (@$scope, @$log, @Meals, @$rootScope, @usSpinnerService, @$timeout, @$filter, @$cookieStore) ->
    @showMore = false
    @items = []
    @$scope.isLoading = true
    @typesMap = {}
    @defaultFiltersKitchen = {
      categoriesMap: {}
      modalFavs: false
      products: []
    }
    @filtersKitchen = @$cookieStore.get('switchfit_filters_kitchen')
    if @filtersKitchen
      @filtersKitchen = _.assign(angular.copy(@defaultFiltersKitchen), @filtersKitchen)
    else
      @filtersKitchen = angular.copy(@defaultFiltersKitchen)

    @onlyFavs = @filtersKitchen.favs
    if !@isPromise(@Meals.allFilters)
      @Meals.allFilters = @Meals.filters()
    @Meals.allFilters.$promise.then (filters) =>
      @filters = filters
      @products = angular.copy(filters.products)
      @products.forEach (product) =>
        if @filtersKitchen.products.length == 0
          product.checked = true
        else
          if product.id in @filtersKitchen.products
            product.checked = true
          else
            product.checked = false
      @types = filters.types
      for t in filters.types
        @typesMap[t.slug] = t.id

      if @$scope.day.timetableItems[@$scope.timetableItemIndex] isnt undefined
        typesByPosition = ['meal_a','meal_b','meal_c','workout','meal_c']
        typeByTimetableItem = null
        if @$scope.day.timetableItems[@$scope.timetableItemIndex].itemType isnt undefined and
          @$scope.day.timetableItems[@$scope.timetableItemIndex].itemType isnt null and
          @$scope.day.timetableItems[@$scope.timetableItemIndex].itemType.slug isnt undefined and
          @$scope.day.timetableItems[@$scope.timetableItemIndex].itemType.slug.length > 0
            typeByTimetableItem = @$scope.day.timetableItems[@$scope.timetableItemIndex].itemType.slug

        if @$scope.day.type == 'detox'
          type = @types.filter (type) =>
            type.slug == 'detox'
          if type.length > 0
            @type = type[0].id
        else
          type = @types.filter (type) =>
            if typeByTimetableItem.length > 0
              type.slug == typeByTimetableItem
            else
              type.slug == typesByPosition[@$scope.timetableItemIndex]
          if type.length > 0
            @type = type[0].id

      if !@isPromise(@Meals.allCategories)
        @Meals.allCategories = @Meals.categories()
      @Meals.allCategories.$promise.then (categories) =>
        @categories = categories
        @filterCategories()
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
        @allMeals = meals
        @$timeout () =>
          @$scope.isLoading = false
          @usSpinnerService.stop('kitchen-loader')
        , 200

  filterCategories: =>
    if @type == 0
      @category = 0
      return @categories

    if @types?
#      categoryId = @$rootScope.preferredMealCategory.id
      subCategories = @types.filter((type) => type.id == @type)[0]?.categories
      @categories = [ { id: 0, title: 'Alle Kategorien' } ]

      if subCategories isnt undefined
        @categories = @categories.concat(subCategories)

#      if categoryId in (@categories.map (category) -> category.id)
#        @category = categoryId
#      else
#        @category = 0
    @categories

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
    @filtersKitchen.modalFavs = @onlyFavs
    @$cookieStore.put('switchfit_filters_kitchen', @filtersKitchen)

  filterMeals: =>
    if @allMeals?
      orderBy = @$filter('orderBy')
      @items = orderBy @allMeals, '-favorite'
      @items = orderBy @items, 'sort'

    if @type != 0
      @items = @items.filter (meal) =>
        if meal.favorite
          meal.sort = 0
        inTypes = meal.type.filter (type) =>
          type.id == @type
        if inTypes.length > 0
          true
        else
          false
    @filteredMealsByTypeLength = @items.length

    if @category != 0
      @items = @items.filter (meal) =>
        inCategories = meal.category.filter (category) =>
          category.id == @category
        if inCategories.length > 0
          true
        else
          false

    if @onlyFavs
      @items = @items.filter (meal) -> meal.favorite == true

    if @products?
      excludedProducts = @products.filter (product) -> !product.checked
      if excludedProducts.length > 0
        excludedProductsIds = excludedProducts.map (product) -> product.id
        @items = @items.filter (meal) =>
          if meal.product.length == 0
            return true
          inExcludedProducts = meal.product.filter (product) -> product.id in excludedProductsIds
          if inExcludedProducts.length > 0
            false
          else
            true
    else
      @items = @items.filter (meal) =>
        if meal.product.length == 0
          true
        else
          false
    @currentFilteredMealsLength = @items.length
    @items

  selectMeal: (meal) =>
    @$rootScope.$broadcast('meal_modal.select', { day: @$scope.day, meal: meal, index: @$scope.timetableItemIndex})
    @$scope.$close()

  resetFilters: =>
    @onlyFavs = false

    # category select fix
    @$timeout () =>
      angular.element('.bootstrap-select.category-select .selectpicker [rel="0"] a[tabindex="0"]').click()
      @category = 0

    @products.forEach (product) =>
      product.checked = true

    @$cookieStore.put('switchfit_filters_kitchen', @defaultFiltersKitchen)
    return


  isPromise: (obj) ->
    if angular.isObject(obj) &&
      angular.isObject(obj.$promise) &&
      obj.$promise.then instanceof Function &&
      obj.$promise["catch"] instanceof Function &&
      obj.$promise["finally"] instanceof Function
       return true
    return false

FoodModal.$inject = [ '$scope', '$log', 'Meals', '$rootScope', 'usSpinnerService', '$timeout', '$filter', '$cookieStore' ]

angular.module('switchfitApp.dashboard')
  .controller 'FoodModalCtrl', FoodModal
