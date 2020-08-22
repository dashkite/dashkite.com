import Path from "path"

www = Path.resolve "src", "www"

baseConfig =
  target: "node"
  node:
    global: true
  entry:
    "origin-request": Path.resolve "src/edge/origin-request/index.coffee"
    "viewer-request": Path.resolve "src/edge/viewer-request/index.coffee"
  output:
    path: Path.resolve "build/edge"
    filename: "[name].js"
    libraryTarget: 'umd'
  module:
    rules: [
      test: /\.coffee$/
      use: [ "coffee-loader"]
    ,
      test: /\.pug$/
      loader: "pug-loader"
      # TODO why doesn't this work?
      #      was trying to make index.pug a symlink to templates/page.pug
      #      but loader fails to resolve /templates/head
      options: basedir: www
    ,
      test: /.yaml$/
      type: "json"
      loader: "yaml-loader"
    ]
  resolve:
    mainFiles: [ "index" ]
    mainFields: [ "main:coffee", "module", "main" ]
    extensions: [ ".js", ".json", ".coffee" ]
    modules: [ "node_modules" ]
    alias:
      configuration: "#{www}/configuration.coffee"
      helpers: "#{www}/helpers/index.coffee"
      resources: "#{www}/resources/"
      templates: "#{www}/templates/"

export default baseConfig
