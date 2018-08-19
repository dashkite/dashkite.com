F = require "fs"
P = {dirname, extname, basename} = require "path"
{task, src, dest, series, parallel, watch} = require "gulp"

merge = (objects...) -> Object.assign objects...

rmDir = require "del"
coffeescript = require "coffeescript"

md = do ->
  mdit = require "markdown-it"
  _md = mdit
    html: true
    linkify: true
    typographer: true
  .use (require "markdown-it-anchor")
  .use (require "markdown-it-implicit-figures"), figcaption: true
  (text) -> _md.render text

socialIcons = require "simple-icons"

thru = require "through2"

plugin = (f) ->
  thru.obj (file, encoding, callback) ->
    await f file, encoding
    callback null, file

pluck = (key, f) ->
  plugin (file) -> f file[key]

ext = (extension) ->
  plugin (file) ->
    file.extname = extension

content = (f) ->
  plugin (file, encoding) ->
    file.contents = Buffer.from await f (file.contents.toString encoding), file

Handlebars = require "handlebars"

identity = (x) -> x

join = (d, array) -> array.join d

block = (f) ->
  (args..., options) ->
    if options.fn?
      join "", f args..., options.fn
    else
      f args..., identity

Handlebars.registerHelper
  indent: (n, string='') ->
    string.replace /\n/g, "\n#{' '.repeat n}"

  values: block (object, f) -> f value for key, value of object

  filter: block (property, value, objects, f) ->
    (f object) for object in objects when object[property] == value

  sortBy: block (property, objects, f) ->
    objects.sort (a, b) ->
      switch
        when (a[property] < b[property]) then -1
        when (a[property] > b[property]) then 1
        else 0
    (f object) for object in objects

  reverse: block (objects, f) ->
    objects.reverse()
    (f object) for object in objects

  limit: block (n, objects, f) ->
    (f object) for object in objects[..n]

YAML = require "js-yaml"

R =
  key: (name) ->
    extension = P.extname name
    P.basename name, extension
  keys: (path) ->
    [keys..., name] = path.split P.sep
    key = R.key name
    if key == "index" then keys else [ keys..., key ]
  traverse: (data, keys) ->
    for key in keys
      data = (data[key] ?= {})
    data

Site =
  data: {}
  get: (path) ->
    R.traverse Site.data, R.keys path
  set: (path, value) ->
    [keys..., key] = R.keys path
    (R.traverse Site.data, keys)[key] = value

vdest = ->
  plugin (file) ->
    Site.set file.relative, file.data

Plugins =
  pug: require "gulp-pug"
  stylus: require "gulp-stylus"
  coffee: require "gulp-coffee"
  server: require "gulp-webserver"
  handlebars: ->
    content (string, file) ->
      data =
        site: Site.data
        local: Site.get file.relative
      (Handlebars.compile string)(data)
  data: ->
    content (string, file) ->
      file.data = YAML.safeLoad string
      string

globext = (extension) ->
  [ "www/**/*.#{extension}", "!**/-*/**" ]

task "serve", ->
  src "build"
  .pipe Plugins.server
    livereload: false
    port: 8081

task "clean", ->
  Site.data = {}
  rmDir "build"

task "data", ->
  src globext "yaml"
  .pipe Plugins.handlebars()
  .pipe Plugins.data()
  .pipe vdest()

task "html", ->
  src (globext "pug"), follow: true
  .pipe Plugins.handlebars()
  .pipe Plugins.pug
    basedir: "www"
    filters:
      markdown: md
  .pipe dest "build"

task "css", ->
  src globext "styl"
  .pipe Plugins.handlebars()
  .pipe Plugins.stylus
    include: [ P.resolve "www" ]
  .pipe dest "build"

# TODO: integrate WebPack
task "js", ->
  src (globext "coffee"), sourcemaps: true
  .pipe Plugins.handlebars()
  .pipe Plugins.coffee coffee: coffeescript
  .pipe dest "build"

task "markdown", ->
  templates = {}
  src (globext "md")
  .pipe content (_, file) ->
    {template} = Site.get file.relative
    templates[template] ?= do ->
      F.readFileSync if template[0] == "/"
        P.join "www", template
      else
        P.join (P.dirname file.path), template
  .pipe Plugins.handlebars()
  .pipe Plugins.pug
    basedir: "www"
    filters: markdown: md
  .pipe dest "build"

task "assets", ->
  src [ "www/**/*.{css,svg,png,jpg,ico,gif}" ], base: "www"
  .pipe dest "build"

build = series "clean", "data",
  parallel "html", "css", "js", "markdown", "assets"

task "build", build
task "watch", -> watch [ "www/**/*" ], build
task "default", series "build", parallel "watch", "serve"
