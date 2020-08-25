import fetch from "node-fetch"
import cheerio from "cheerio"
import {curry, rtee} from "@pandastrike/garden"
import Registry from "@dashkite/helium"
import "pages"
import * as n from "./neon-server"
import template from "../../www/index.pug"

globalThis.fetch ?= fetch
globalThis.$ = cheerio.load template()
globalThis.window ?= {}

Registry.set neon: n
