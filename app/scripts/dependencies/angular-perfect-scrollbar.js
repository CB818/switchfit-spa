angular.module('perfect_scrollbar', []).directive('perfectScrollbar', ['$parse', function($parse) {
  return {
    restrict: 'E',
    transclude: true,
    template:  '<div><div ng-transclude></div></div>',
    replace: true,
    link: function($scope, $elem, $attr) {
      $elem.perfectScrollbar({
        wheelSpeed: $parse($attr.wheelSpeed)() || 10,
        wheelPropagation: $parse($attr.wheelPropagation)() || false,
        minScrollbarLength: $parse($attr.minScrollbarLength)() || null,
        useBothWheelAxes: $parse($attr.useBothWheelAxes)() || false,
        suppressScrollX: $parse($attr.suppressScrollX)() || false,
        suppressScrollY: $parse($attr.suppressScrollY)() || false,
        scrollXMarginOffset: $parse($attr.scrollXMarginOffset)() || 0
      });

      if ($attr.refreshOnChange) {
        $scope.$watchCollection($attr.refreshOnChange, function(newNames, oldNames) {
          // I'm not crazy about setting timeouts but it sounds like thie is unavoidable per
          // http://stackoverflow.com/questions/11125078/is-there-a-post-render-callback-for-angular-js-directive
          setTimeout(function() { $elem.perfectScrollbar('update'); }, 10);
        });
      }
    }
  };
}]);
