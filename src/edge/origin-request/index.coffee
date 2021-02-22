import "source-map-support/register"
import Router from "@dashkite/oxygen"
import {media, preview, feed, application} from "./handlers"
import {respond, log} from "./helpers"

router = Router.create()

router.add "/content{/path*}", {}, media
router.add "/media{/path*}", {}, media
router.add "/application.js", {}, media
router.add "/preview", {}, preview
router.add "/blog/{format}/{tag}", {}, feed
router.add "{/path*}", {}, application


handler = (event, context, callback) ->

  log event
  {request} = event.Records[0].cf

  try
    router.dispatch request.uri, {request, callback}
  catch error
    console.error e
    callback null,
      respond context, status: "503"

export {handler}
