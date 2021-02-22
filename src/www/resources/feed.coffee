import FeedCombiner from "rss-combiner"

Preview =
  get: ({format, tag}) ->
    feed = await FeedCombiner
      size: 100
      feeds: [
        "https://byline-api.dashkite.com/#{format}/dashkite/#{tag}"
        "https://byline-api.dashkite.com/#{format}/dan/#{tag}"
        "https://byline-api.dashkite.com/#{format}/david/#{tag}"
      pubDate: new Date()
      ]
    feed.xml()

export default Preview
