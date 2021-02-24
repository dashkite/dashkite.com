import * as g from "@pandastrike/garden"
import * as m from "@dashkite/mercury"

get = g.curry (name, object) -> object[name]

Feed =

  get: ({format, tag}) ->
    do g.flow [
      m.use m.Fetch.client {mode: "cors"}
      m.template "https://staging-www.dashkite.com/blog/{format}/{tag}"
      m.parameters {format, tag}
      m.method "get"
      # m.accept "application/#{format}+xml"
      m.request
      m.expect.status [ 200 ]
      # m.expect.media "application/#{format}+xml"
      m.text
      get "text"
    ]

export {Feed}
