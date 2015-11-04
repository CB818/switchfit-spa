'use strict'

angular.module('switchfitApp').factory "$translateSwitchfitLoader", [
  "$q"
  "$http"
  ($q, $http) ->
    return (options) ->
      throw new Error("Couldn't load static files, no prefix or suffix specified!")  if not options or (not angular.isString(options.prefix) or not angular.isString(options.suffix))
      deferred = $q.defer()
      $http(
        url: [
          options.prefix
          options.domain
          options.suffix
        ].join("")
        method: "GET"
        params: {
          locales: options.key
        }
      ).success((data) ->
        deferred.resolve data.translations[options.key][options.domain]
        return
      ).error (data) ->
        deferred.reject options.key
        return

      deferred.promise
]