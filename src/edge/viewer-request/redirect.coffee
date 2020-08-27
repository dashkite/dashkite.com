redirect = (request, location) ->
  status: "301",
  statusDescription: "301 Moved Permanently"
  headers:
    "location": [
      key: "Location"
      value: location
    ]

export default redirect
