import combine from "rss-combiner"
import {Feed as Builder} from "feed"
Parser = require "rss-parser"

Feed =

  get: ({format, tag}) ->

    parser = new Parser headers: Accept: "application/#{format}+xml"

    base = "https://byline-api.dashkite.com"

    feeds = await Promise.all [
      parser.parseURL "#{base}/#{format}/dashkite/#{tag}"
      parser.parseURL "#{base}/#{format}/dan/#{tag}"
      parser.parseURL "#{base}/#{format}/david/#{tag}"
    ]

    items  = feeds
      .reduce ((items, feed) -> items.concat feed.items), []
      .sort ((a, b) -> b.isoDate.localeCompare a.isoDate, "en")

    feed = new Builder
      title: "DashKite Blog Feed"
      id: "https://dashkite.com/blog/#{format}/#{tag}"
      link: "https://dashkite.com/blog/#{format}/#{tag}"
      favicon: "https://dashkite.com/media/images/favicon.ico"

    # TODO possibly just replace with pug templates?
    add = (feed, item) ->
      feed.addItem
        id: item.id
        title: item.title
        author: name: item.author
        link: item.link
        date: new Date item.isoDate
        description: item.summary
      feed

    items.reduce add, feed

    switch format
      when "atom" then feed.atom1()
      when "rss" then feed.rss2()

export {Feed}
