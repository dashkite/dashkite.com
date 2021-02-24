import assert from "assert"
import {print, test, success} from "amen"
import cheerio from "cheerio"

# install global fetch
import fetch from "node-fetch"
global.fetch = fetch

import {Application, Preview, Feed} from "./resources"
# import {Application, Preview} from "./resources"
# import {Feed} from "../../src/edge/origin-request/handlers/feed/resources"

do ->
  print await test "dashkite.com edge tests", [

    test "application handler", [

      test
        description: "home page",
        wait: 5000
        ->
          $ = cheerio.load await Application.get "/"
          assert.equal ($ "title").text()?, true
          assert.equal ($ "meta[name='description']").attr("content")?, true
          assert.equal ($ "script[async]").attr("src")?, true

      test
        description: "product page",
        wait: 5000
        ->
          $ = cheerio.load await Application.get "/products"
          assert.equal ($ "title").text()?, true
          assert.equal ($ "meta[name='description']").attr("content")?, true

    ]

    test "preview handler", [

      test
        description: "preview",
        wait: 5000
        ->
          preview = await Preview.get url: "https://byline.dashkite.com/\
            post/dashkite/-7h5X90ovPH1EvMMOByQEQ/week-in-review-feb-19-2021"
          assert.equal "Dan Yoder", preview.author
          assert.equal "Week In Review", preview.title

    ]

    test "feed handler", [

      test
        description: "feed"
        wait: 10000
        ->
          console.log feed: await Feed.get format: "atom", tag: "all"
    ]

    test "media handler"

  ]

  if !success then process.exit 1
