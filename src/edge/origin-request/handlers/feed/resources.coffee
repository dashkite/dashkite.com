import cheerio from "cheerio"
import * as g from "@pandastrike/garden"
import * as r from "panda-river"
import atom from "./atom.pug"
import rss from "./rss.pug"

formats =
  atom:
    render: atom
    selectors:
      item: "entry"
      date: "updated"
  rss:
    render: rss
    selectors:
      item: "item"
      date: "pubDate"

Feed =

  get: ({format, tag}) ->

    {render, selectors} = formats[format]

    base = "https://byline-api.dashkite.com"

    items = await do g.flow [
      g.wrap [
        "#{base}/#{format}/dashkite/#{tag}"
        "#{base}/#{format}/dan/#{tag}"
        "#{base}/#{format}/david/#{tag}"
      ]
      r.wait r.map g.flow [
        fetch
        (response) -> response.text()
        (xml) -> cheerio.load xml, {xml: xmlMode: true}, false
        ($) ->
          ($ selectors.item).map (_, e) ->
            xml: $.xml $ e
            date: (new Date (($ e).find selectors.date).text()).toISOString()
        (nodes) -> Array.from nodes
      ]
      r.reduce ((items, feed) -> items.concat feed), []
      (items) -> items.sort ((a, b) -> b.date.localeCompare a.date, "en")
      r.map ({xml}) -> xml
      r.collect
    ]

    feed =
      title: "DashKite Blog Feed"
      id: "https://dashkite.com/blog/#{format}/#{tag}"
      link: "https://dashkite.com/blog/#{format}/#{tag}"
      favicon: "https://dashkite.com/media/images/favicon.ico"
      items: items

    render feed

export {Feed}
