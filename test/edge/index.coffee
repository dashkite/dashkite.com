import Path from "path"
import assert from "assert"

import http from "http"
# import finalhandler from "finalhandler"
import _server from "serve-static"

import {print, test, success} from "amen"
import Registry from "@dashkite/helium"

import "../../src/edge/origin-request/pages"

server = (path, {port, fallback}) ->
  handler = _server path,
    index: [ fallback ]
    port: port
    fallthrough: false
  http
  .createServer handler
  .listen port

do ->
  print await test
    description: "Hype Edge"
    wait: 5000
    ->
      server = server (Path.resolve "build/www"),
        port: 3000
        fallback: "index.html"

      router = Registry.get "router"

      await router.dispatch url: "/"

      assert.equal ($ "title").text()?, true
      assert.equal ($ "meta[name='description']").attr("content")?, true
      assert.equal ($ "script[async]").attr("src")?, true

      await router.dispatch url: "/products"
      assert.equal ($ "title").text()?, true
      assert.equal ($ "meta[name='description']").attr("content")?, true
      server.close()

  if !success then process.exit 1
