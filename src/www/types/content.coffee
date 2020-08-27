import Descriptor from "resources/descriptor"
import Markup from "resources/markup"

class Content

  @load: ({path}) ->
    content = new Content
    await content.load path
    content

  load: (@path) ->
    try
      Object.assign @, await Descriptor.get @path
      @content = await Markup.get @path
    catch error
      console.log error
      console.log "content", error.context
      console.log "response status": error.response.status
      console.log "response.body": await error.response.text()
      throw error

export default Content
