import { HTML, SVG } from "@dashkite/html-render"

compact = ( items ) -> items.filter ( x ) -> x?

block =  ({ key, content }) ->
  if content?
    HTML.div id: key,
      render item for item in content

heading = do ( level = 1 ) ->
  ( title ) ->
    if level == 1
      level = 2
      HTML.h1 title
    else
      HTML.h2 title

text = ({ data, content }) ->
  if data.title?
    HTML.section [
      HTML.header [ heading data.title ]
      HTML.parse content.media.content
    ]
  else
    HTML.parse content.media.content

svg = ( item ) ->
  ( SVG.parse item.content )[0]

Media = { svg }

media = ({ data, content }) ->
  { type, key } = content.media
  if ( render = Media[ type ] )?
    render content.media
  else
    console.error "Error: unknown media type: #{ type } for [ #{ key } ]"

image = ( item ) ->
  # TODO possibly render figure caption etc
  media item
    
navigation = ({ data }) ->
  HTML.nav [
    for { target, title } in data.items
      HTML.a href: target, title
  ]

link = ({ data }) ->
  if data.hints?.style?
    HTML.a
      class: data.hints.style
      href: data.target
      data.text
  else
    HTML.a
      href: data.target
      data.text

Render = { block, text, image, link, navigation }

render = ( item ) ->
  { key, type } = item
  if ( _render = Render[ type ])?
    _render item
  else
    console.error "Error: unknown resource type: #{ type } for [ #{ key } ]"

slot = ({ key, type, content }) ->
  if content?
    compact ( render item for item in content )

page = ({ data, slots }) ->

    HTML.render HTML.html [

      HTML.head [
        HTML.title data.title
      ]

      HTML.body [

        HTML.header [
          slot slots.header
        ]

        HTML.main [
          slot slots.main
        ]

        HTML.footer [
          slot slots.footer
        ]
      ]
    ]

export { page }



