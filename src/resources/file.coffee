import * as Fn from "@dashkite/joy/function"
import * as Obj from "@dashkite/joy/object"
import * as Ks from "@dashkite/katana/sync"
import * as Me from "@dashkite/mercury"

initialize = Fn.pipe [
  Ks.assign [
    Ks.push Obj.get "base"
    Me.base
  ]
  Ks.assign [
    Ks.push Obj.get "path"
    Me.path
  ]
  Ks.assign [
    Ks.push Obj.get "headers"
    Me.headers
  ]
]

File =

  get: Me.start [
    initialize
    Me.method "get"
    Me.expect.status [ 200 ]
    Me.request
    Me.text
    Ks.get
  ]

  put: Me.start [
    initialize
    Ks.assign [
      Ks.push Obj.get "content"
      Me.content
    ]
    Me.method "put"
    Me.expect.status [ 204 ]
    Me.request
  ]

  delete: Me.start [
    initialize
    Me.method "delete"
    Me.expect.status [ 204 ]
    Me.request
  ]

export default File
