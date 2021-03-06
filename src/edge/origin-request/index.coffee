import "source-map-support/register"
import Router from "@dashkite/oxygen"
import {media, preview, feed, application} from "./handlers"
import {respond, log} from "./helpers"

# install global fetch
import fetch from "node-fetch"
global.fetch = fetch

router = Router.create()

router.add "/", { name: "root" }, application
router.add "/content{/path*}", { name: "content" }, media
router.add "/media{/path*}", { name: "media" }, media
router.add "/application.js", { name: "application.js" }, media
router.add "/preview{?url}", { name: "preview" }, preview
router.add "/blog/{format}/{tag}", { name: "feed" }, feed
router.add "{/path*}", { name: "application" }, application

handler = (event, context, callback) ->

  log event
  {request} = event.Records[0].cf

  try
    # sigh...
    url = if request.querystring? && request.querystring != ""
      "#{request.uri}?#{request.querystring}"
    else request.uri
    router.dispatch {url}, {url, request, callback}
  catch error
    console.error error
    callback null,
      respond context, status: "503"

export {handler}
