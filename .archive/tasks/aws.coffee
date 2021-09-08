import os from "os"
import {promises as fs} from "fs"
import {sep, resolve} from "path"

import SDK from "aws-sdk"

import {flow, tee, curry} from "@pandastrike/garden"
import {toJSON, include} from "panda-parchment"
import {mkdirp, write, rmr} from "panda-quill"
import * as w from "@dashkite/zenpack"
import Sundog from "sundog"

checkAWSCredentials = tee ->
  if ! process.env["AWS_PROFILE"]?
    throw new Error "Environment variable AWS_PROFILE must be defined"

setupTempDirectory = curry (aws, webpack) ->
  console.log "establishing temporary directory"
  config = {aws, webpack}
  tmpDir = os.tmpdir()
  config.aws.temp = await fs.mkdtemp "#{tmpDir}#{sep}"
  config

readVault = (config) ->
  console.log "pulling secrets from AWS SecretsManager"
  sundog = Sundog
    region: config.aws.region
    sslEnabled: true
  {read} = sundog.ASM()

  config.aws.vault = {}
  for name in (config.aws.secrets ? [])
    config.aws.vault[name] = await read name

  config

writeVault = (config) ->
  console.log "establishing environment secrets"

  await write (resolve config.aws.temp, "vault.json"),
    toJSON config.aws.vault

  config

appendAlias = (config) ->
  include config.webpack.resolve.alias,
    "-sky-vault": resolve config.aws.temp, "vault.json"

  config

setup = (config) ->
  flow [
    checkAWSCredentials
    setupTempDirectory config
    readVault
    writeVault
    appendAlias
  ]

cleanup = (config) ->
  console.log "removing temporary directory data"
  await rmr config.aws.temp
  config

run = (config) ->
  flow [
    setup config
    tee ({webpack}) -> w.run webpack
    cleanup
  ]

export {setup, cleanup, run}
