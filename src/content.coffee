load = (path) ->
  data = require "./content/#{path}/index.yaml"
  data.html = require "./content/#{path}/index.md"
  data

export {load}
