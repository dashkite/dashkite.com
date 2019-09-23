import marked from "marked"

load = (path) ->
  data = require "./content/#{path}.yaml"
  data.html = marked (require "./content/#{path}.md").default
  data

export {load}
