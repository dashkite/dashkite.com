attempt = ([fx..., g]) ->
  (ax...) ->
    for f, i in fx
      try
        return await f ax...
    g ax...

export {attempt}
