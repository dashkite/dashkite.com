import {Gadget, mixin, tag, bebop, shadow,
  render, properties, events, local} from "panda-play"

import {load} from "../../content"

import {describe, resource} from "../mixins"
import {smart} from "../combinators"

import template from "./index.pug"

class extends Gadget

  mixin @, [

    tag "starfire-post"

    bebop, shadow, describe #, navigate, queryable

    resource -> @value = load @dom.dataset.key

    render smart template

  ]
