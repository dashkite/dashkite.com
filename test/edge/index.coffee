import Path from "path"
import assert from "assert"

import cheerio from "cheerio"

import {print, test, success} from "amen"
import Registry from "@dashkite/helium"
import * as b from "@dashkite/brick"

import "../../src/edge/origin-request/pages"

do ->
  print await test
    description: "Hype Edge"
    wait: 5000
    ->
      router = Registry.get "router"

      await router.dispatch url: "/"
      assert.equal ($ "title").text(), "DashKite: Take Back The Web"
      assert.equal ($ "meta[name='description']").attr("content"),
        "DashKite combines an expertise in distributed design with
          the most advanced Web technologies to build great products."

      server = b.server (Path.resolve "build/www"),
        port: 3000
        fallback: "index.html"

      await router.dispatch url: "/products"
      assert.equal ($ "title").text(), "DashKite: Our Products"
      assert.equal ($ "meta[name='description']").attr("content"),
        "We provide products and services to empower you to take back your Web.
          Create your homepage, start a blog, chat with your friends, and stay
          on top of all your favorite content."
      server.close()

  if !success then process.exit 1
