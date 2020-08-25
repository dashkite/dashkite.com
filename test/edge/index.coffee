import {print, test, success} from "amen"
import assert from "assert"
import Registry from "@dashkite/helium"
import cheerio from "cheerio"
import "../../src/edge/origin-request/pages"

do ->
  print await test
    description: "Hype Edge"
    wait: 5000
    ->
      router = Registry.get "router"

      $ = cheerio.load await router.dispatch url: "/"
      assert.equal ($ "title").text(), "Hype: Your Page On The Web"
      assert.equal ($ "meta[name='description']").attr("content"), "You deserve the hype."

      $ = cheerio.load await router.dispatch url: "/foo/bar/baz"
      assert.equal ($ "title").text(), "Hype: Your Page On The Web"
      assert.equal ($ "meta[name='description']").attr("content"), "You deserve the hype."

      # TODO: come up with a better fixture situation here.
      $ = cheerio.load await router.dispatch url: "/view/dan"
      assert.equal ($ "title").text(), "dan"
      assert.equal ($ "meta[name='description']").attr("content"),
        "Hype page for dan"

  if !success then process.exit 1
