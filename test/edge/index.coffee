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
      assert.equal ($ "title").text(), "DashKite: It's Your Web"
      assert.equal ($ "meta[name='description']").attr("content"),
        "DashKite combines an expertise in distributed design with
          the most advanced Web technologies to build great products."

      await router.dispatch url: "/products"
      assert.equal ($ "title").text(), "DashKite: Our Products"
      assert.equal ($ "meta[name='description']").attr("content"),
        "We provide products and services to empower you to take back your Web.
          Create your homepage, start a blog, chat with your friends, and stay
          on top of all your favorite content."
      server.close()

  if !success then process.exit 1
