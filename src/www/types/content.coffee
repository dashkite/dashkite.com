import Descriptor from "resources/descriptor"
import Markup from "resources/markup"

class Content

  @load: ({path}) ->
    content = new Content
    await content.load path
    content

  @loadFrom: (object) ->
    content = new Content
    Object.assign content, object
    content

  load: (@path) ->
    Object.assign @, await Descriptor.get @path
    @content = await Markup.get @path



export default Content
