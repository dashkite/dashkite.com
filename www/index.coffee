$.ready.then ->

  nouns = ($ ".tagline span")

  rotate = do (index = 0) ->
    next = (n) ->
    ->
      $(nouns.get index++).toggleClass "selected"
      index %= nouns.length
      $(nouns.get index).toggleClass "selected"
      setTimeout rotate, 2000

  setTimeout rotate, 2000
