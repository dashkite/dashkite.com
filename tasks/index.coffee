import * as t from "@dashkite/genie"
import preset from "@dashkite/genie-presets"
import sky from "@dashkite/sky-presets"

preset t
sky t

import FS from "node:fs/promises"
import Path from "node:path"
import YAML from "js-yaml"
import * as Render from "./render"
import * as Markdown from "markdown-wasm"

markdown = undefined

isString = ( value ) -> value.substring?

Files =

  list: ( root ) ->
    queue = [ root ]
    while queue.length > 0
      current = queue.pop()  
      for file in ( await FS.readdir current ) when !( file.startsWith "." )
        if ( await FS.stat ( path = Path.join current, file ) ).isDirectory()
          queue.push path
          yield 
            type: "directory"
            path: Path.relative root, path
        else
          yield 
            type: "file"
            path: Path.relative root, path
            content: await FS.readFile path, "utf8"

Key =

  parse: ( component ) ->
    if ( match = component.match /^((\d+)\:)?([\w\-]+)(\.([\w\-]+))?$/ )?
      [ , , index, name, , type ] = match
      { name, type, index: ( parseInt index if index? )}
    else
      throw new Error "malformed path component [ #{ component} ]"
  
  make: ( path ) ->
    do ->
      for component in path.split "/"
        ( Key.parse component ).name
    .join "/"


Resource = 

  dictionary: {}

  expand: ( reference, level = 1 ) ->
    resource = @dictionary[ reference ]
    if resource.content? && Array.isArray resource.content
      resource.content =
        for reference in resource.content when isString reference
          @expand reference
    resource

  render: ( path ) ->

    if ( resource = @dictionary[ path ] )?
      if resource.type == "page"
        if ( template = @dictionary[ resource.data.template ])?
          if template.type == "template"
            resource.slots = { template.slots..., resource.slots... }
        slots = {}
        for name, reference of resource.slots
          slots[ name ] = @expand reference
        resource.slots = slots
        Render.page resource

  make: ( file ) ->
    key = Key.make file.path
    parent = Path.dirname key
    description = Key.parse Path.basename file.path
    content = data = undefined
    if file.path.endsWith ".yaml"
      data = YAML.load file.content
    else if file.path.endsWith ".md"
      content = markdown.parse file.content
    else if file.content?
      content = file.content
    { key, parent, content, data, description... }

t.define "build", ->

  markdown = await Markdown.ready

  resources = Resource.dictionary

  for await file from await Files.list "src"
    resource = Resource.make file
    resources[ resource.key ] = resource

  performance.mark "compose:start"
  for resource in Object.values resources
    if ( parent = resources[ resource.parent ] )?
      if resource.index?
        parent.content ?= []
        parent.content[ resource.index - 1 ] = resource.key
      else if resource.type == "slot"
        parent.slots ?= {}
        parent.slots[ resource.name ] = resource.key
      else if resource.data?
        parent.data = resource.data
        delete resources[ resource.key ]
      else if resource.content?
        parent.content = media: resource
        delete resources[ resource.key ]
  performance.mark "compose:finish"

  performance.mark "render:start"
  html = Resource.render "home"
  performance.mark "render:finish"

  performance.measure "compose", "compose:start", "compose:finish"
  performance.measure "render", "render:start", "render:finish"

  entries = performance.getEntriesByType "measure"
  for entry in entries
    console.log "benchmark: #{entry.name}", entry.duration, "ms"

  await FS.writeFile "build/index.html", html
