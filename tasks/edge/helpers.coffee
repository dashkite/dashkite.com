import fs from "fs"

import Webpack from "webpack"
import baseConfig from "./base-config"
import {flow, wrap} from "@pandastrike/garden"
import {merge} from "panda-parchment"

shell = do ->
  {exec} = require('child_process')
  (command, options) ->
    new Promise (resolve, reject) ->
      exec command, options, (error, stdout, stderr) ->
        if error
          console.error error
          return reject error

        resolve()

configure = (config) -> merge baseConfig, config

_webpack = (config) ->
  new Promise (resolve) ->
    Webpack config,
      (error, result) -> resolve {error, result}

report = ({error, result}) ->
  console.error result.toString colors: true
  if error? || result.hasErrors()
    throw error

  fs.writeFileSync "webpack-stats.json", JSON.stringify result.toJson()


webpack = flow [
  configure
  _webpack
  report
]

export {
  shell,
  webpack
}
