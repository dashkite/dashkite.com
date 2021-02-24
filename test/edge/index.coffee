import assert from "assert"
import {print, test, success} from "amen"
import cheerio from "cheerio"

# install global fetch
import fetch from "node-fetch"
global.fetch = fetch

import {Application, Preview, Feed} from "./resources"

timeout = 2000

do ->

  print await test "dashkite.com edge tests [staging]", [

    test "application handler", [

      test
        description: "home page",
        wait: timeout
        ->
          $ = cheerio.load await Application.get "/"
          assert.equal ($ "title").text()?, true
          assert.equal ($ "meta[name='description']").attr("content")?, true
          assert.equal ($ "script[async]").attr("src")?, true

      test
        description: "product page",
        wait: timeout
        ->
          $ = cheerio.load await Application.get "/products"
          assert.equal ($ "title").text()?, true
          assert.equal ($ "meta[name='description']").attr("content")?, true

    ]

    test "preview handler", [

      test
        description: "preview",
        wait: timeout
        ->
          preview = await Preview.get url: "https://byline.dashkite.com/\
            post/dashkite/-7h5X90ovPH1EvMMOByQEQ/week-in-review-feb-19-2021"
          assert.equal "Dan Yoder", preview.author
          assert.equal "Week In Review", preview.title

    ]

    test "feed handler", [

      test
        description: "atom"
        wait: timeout
        ->
          $ = cheerio.load await Feed.get format: "atom", tag: "all"
          assert.equal ($ "title").text()?, true

      test
        description: "rss"
        wait: timeout
        ->
          $ = cheerio.load await Feed.get format: "rss", tag: "all"
          assert.equal ($ "title").text()?, true

    ]

    test "media handler", [

      test
        description: "application javascript"
        wait: timeout
        ->
          response = await fetch "https://\
            staging-www.dashkite.com/\
            application.js"
          assert.equal 200, response.status
          assert.equal "application/javascript",
            response.headers.get "content-type"


    ]

  ]

  if !success then process.exit 1
