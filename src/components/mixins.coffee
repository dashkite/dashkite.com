import {ready, property, events, local} from "panda-play"
import {pipe as _pipe, spread} from "panda-garden"

pipe = spread _pipe

describe = ->

  # convert a dataset into an ordinary object
  get = (dataset) ->
    r = {}
    r[k] = v for k, v of object when v?
    r

  pipe [

    # define a getter that returns an ordinary object
    property description: get: -> get(@dom.dataset)

    # dispatch 'describe' event when we change an attribute
    ready ->
      new MutationObserver (=> @dispatch "describe")
      .observe @dom, attributes: true

  ]

resource = (get) ->

  pipe [

    ready get

    events
      activate: local get
      describe: local get

  ]

export {describe, resource}
