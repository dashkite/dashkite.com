import * as q from "@dashkite/quark"

export default q.build q.sheet [
  q.select ".page, .view", [
    q.display "none"
  ]
  q.select ".page.active", [
    q.display "block"

    q.select ".view.active", [
      q.display "block"
] ] ]
