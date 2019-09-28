import {Gadget, mixin, tag, bebop, shadow,
  render, properties, events, local} from "panda-play"

import {load} from "../../content"

import {navigate, describe, resource} from "../mixins"
import {smart} from "../combinators"

import template from "./index.pug"

class extends Gadget

  mixin @, [

    tag "raven-banner"

    bebop, shadow, describe, navigate

    resource -> @value = load @dom.dataset.path

    render smart template

  ]
