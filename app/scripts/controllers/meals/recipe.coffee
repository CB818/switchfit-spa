'use strict'

###*
 # @ngdoc function
 # @name switchfitApp.controller:MealsRecipeCtrl
 # @description
 # # MealsRecipeCtrl
 # Controller of the switchfitApp
###
class MealsRecipe
  constructor: ($scope, $stateParams, @Meals, $filter, @$state) ->
    @parentScope = $scope.$parent
    recipeId = $stateParams.recipe
    @Meals.get({ mealId: recipeId }).$promise.then (recipe) =>
      @info = recipe
      @info.ingredients = @info.ingredients.map (ingredient) => { title: ingredient }
      @info.directions = $filter('newLines')(@info.directions)
      @info.additionalInfo = $filter('newLines')(@info.additionalInfo)
      @info.nutritionalInfo = $filter('newLines')(@info.nutritionalInfo)
      $scope.recipePhotos = @info.media

    @isLoading = false
    # initial image index
    $scope._Index = 0

    # if a current image is the same as requested image
    $scope.isActive = (index) ->
      $scope._Index == index

    # show prev image
    $scope.showPrev = ->
      $scope._Index = (if ($scope._Index > 0) then --$scope._Index else $scope.recipePhotos.length - 1)

    # show next image
    $scope.showNext = ->
      $scope._Index = ((if $scope._Index < $scope.recipePhotos.length - 1 then ++$scope._Index else 0))

    # show a certain image
    $scope.showPhoto = (index) ->
      $scope._Index = index

  fav: =>
    id = @info.id
    @isLoading = true
    if @info.favorite
      @Meals.unfav { mealId: id }, {}, (data) =>
        @info.favorite = false
        @isLoading = false
        # update list
        @parentScope.allMeals.filter (meal) ->
          if meal.id == id
            meal.favorite = false
    else
      @Meals.fav { mealId: id }, {}, (data) =>
        @info.favorite = true
        @isLoading = false
        # update list
        @parentScope.allMeals.filter (meal) ->
          if meal.id == id
            meal.favorite = true

  isIngredientSections: (item) =>
    return /^==(.*)==$/.test(item);

  getIngredientSections: (item) =>
    matches = item.match(/^==(.*)==$/)
    if (matches)
      return matches[1]
    else
      return item

MealsRecipe.$inject = [ '$scope', '$stateParams', 'Meals', '$filter', '$state' ]

angular.module('switchfitApp')
  .controller 'MealsRecipeCtrl', MealsRecipe


class DemoMealsRecipe extends MealsRecipe

DemoMealsRecipe.$inject = [ '$scope', '$stateParams', 'DemoMeals', '$filter' ]

angular.module('switchfitApp')
  .controller 'DemoMealsRecipeCtrl', DemoMealsRecipe
