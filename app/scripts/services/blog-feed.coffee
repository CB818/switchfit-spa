'use strict'

class BlogFeed
  constructor: (@FeedLoader) ->
    @feeds = []
  get: () =>
    if @feeds.length == 0
      @FeedLoader.fetch {q: 'https://www.switchfit.io/feed/', num: 10}, {}, (data) =>
        for item in data.responseData.feed.entries
          item.publishedDate = moment(item.publishedDate).format('d. MMMM, h:mm')
          re = /<img[^>]+src="([^">]+)/g
          results = re.exec(item.content)
          item.imgSrc = ''
          if (results != null)
            if results[1].length > 0
              item.imgSrc = results[1]
              item.imgSrc = item.imgSrc.replace('http://www.switchfit.io', 'https://www.switchfit.io')
          tagRe = /(<([^>]+)>)/ig
          item.description = item.content.replace(tagRe, "").substring(0, 450) + ' ...'
          @feeds.push(item)
      return @feeds
    else
      return @feeds

BlogFeed.$inject = [ 'FeedLoader']

angular.module('switchfitApp')
  .factory 'FeedLoader', ($resource) ->
    return $resource '//ajax.googleapis.com/ajax/services/feed/load', {}, {
      fetch: {method: 'JSONP', params: {v: '1.0', callback: 'JSON_CALLBACK'}}
    }
  .service 'BlogFeed', BlogFeed
