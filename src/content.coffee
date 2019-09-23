load = (path) ->
  data = require "./content/#{path}.yaml"
  data.html = require "./content/#{path}.md"
  data

export {load}
