import fetch from "node-fetch"
import {gzip} from "./utils"
import Vault from "-sky-vault"

global.fetch = fetch

vault = Vault["link-preview-production-rapid"]

respond = ({status, cacheControl, body, statusDescription}) ->
  status: status
  statusDescription: statusDescription
  body: await gzip body
  bodyEncoding: "base64"
  headers:
    "access-control-allow-origin": [
      key: "Access-Control-Allow-Origin"
      value: "*"
    ]
    "cache-control": [
        key: "Cache-Control",
        value: cacheControl
    ]
    "content-type": [
        key: "Content-Type",
        value: "application/json"
    ]
    "content-encoding": [
        key: "Content-Encoding",
        value: "gzip"
    ]
    "vary": [
      key: "Vary"
      value: "Accept-Encoding"
    ]

preview = (request) ->
  try
    url = "https://links-api.dashkite.com/preview?#{request.querystring}"
    response = await fetch url,
      headers:
        accept: "application/json"
        "#{vault.header}": "#{vault.value}"

    unless response.status == 200
      console.warn response.status
      console.warn await response.json()
      throw new Error "non 200 response from link preview API."

    respond
      status: "200"
      statusDescription: "200 OK"
      cacheControl: response.headers.get "cache-control"
      body: JSON.stringify await response.json()
  catch e
    console.warn e
    respond
      status: "404"
      statusDescription: "404 Not Found"
      body: JSON.stringify message: "Unable to retrieve preview data for this URL."


export default preview
