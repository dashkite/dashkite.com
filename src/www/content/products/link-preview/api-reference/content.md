## Table Of Contents

<!-- TOC depthFrom:2 depthTo:5 withLinks:1 updateOnSave:0 orderedList:0 -->

- [Resources](#resources)
	- [Preview](#preview)
		- [URL Template](#url-template)
		- [Parameters](#parameters)
			- [Query Parameters](#query-parameters)
		- [Methods](#methods)
			- [Get](#get)
- [Schema](#schema)
	- [Preview Schema](#preview-schema)
	- [Media Schema](#media-schema)
	- [Image Schema](#image-schema)
	- [Video / Audio Schema](#video--audio-schema)
	- [Format Schema](#format-schema)
	- [Player Schema](#player-schema)

<!-- /TOC -->

## Resources

### Preview

Represents normalized data for a *preview* of a given HTML resource, typically a Web page, combining data from oEmbed, Twitter, Open Graph, and generic `<meta>` tags.

We make a best effort to gather available information, with the goal to provide the client with fields that are normalized and may be used safely (ex: the `favicon` will always be a favicon and not a logo.)

However we will not be able to locate data about every site, so all fields in the response are optional. The client must determine whether there is sufficient content to display. If no fields can be provided, this endpoint returns a 404 status.

Clients may use the value of `html`, if available, since this is provider's preferred preview. We recommend placing this HTML within an iframe to minimize the security risk from third-party JavaScript.

The `media` field is a complex data object that specifies multiple categories of media (`image`, `audio`, `video`, or `player`) and, within each, slots for multiple formats. We recommend arranging these as sources within the HTML5 media elements  [`picture`][picture],  [`audio`][audio], and [`video`][video].

#### URL Template

`/preview{?url}`

**Example**

The preview resource for the URL `https://example.com/an-example-link` would be:

`/preview?url=https%3A%2F%2Fexample.com%2Fan-example-link`

**Important:** The `url` parameter must be [URL encoded][encoded-uri].

#### Parameters

##### Query Parameters

| Name | Type/Format        | Description                                                  |
| ---- | ------------------ | ------------------------------------------------------------ |
| url  | string/encoded uri | URL to be previewed. This value should be [an encoded URI][encoded-uri]. |

#### Methods

##### Get

Fetches the site preview data.

###### Request Headers

| Header         | Value                             | Description                                                  |
| -------------- | --------------------------------- | ------------------------------------------------------------ |
| X-RapidAPI-Key | Your RapidAPI Key                 | For RapidAPI customers                                       |
| Authorization  | Your memoized DashKite Web Grant. | For everyone else                                            |
| Accept         | Content type for the response.    | Optional. Defaults to `application/json`, which is currently the only supported value. |

###### Response Headers

| Header           | Value                | Description                                                  |
| ---------------- | -------------------- | ------------------------------------------------------------ |
| Content-Type     | `application/json`   |                                                              |
| Content-Encoding | `gzip` or `identity` |                                                              |
| Status           | `200` or `304`       | When successful. See [Response Status Codes](#response-status-codes). |
| Cache-Control    | `max-age=60`         |                                                              |
| ETag             | `true`               |                                                              |

###### Response Status Codes

| Status | Meaning               | Description                                                  |
| ------ | --------------------- | ------------------------------------------------------------ |
| 200    | OK                    | Request was successful and response body contains preview data for the given URL. |
| 304    | Not Modified          | The preview data has not changed and the cached version is safe to use. |
| 400    | Bad Request           | The given URL is not valid.                                  |
| 404    | Not Found             | The resource for the given URL cannot be found.              |
| 406    | Not Acceptable        | The content type specified by the `accept` header is unsupported. Presently, the only supported format is `application/json`. |
| 500    | Internal Server Error | The server encountered an unexpected condition that prevented it from fulfilling the request. |

###### Response Body

See *Preview Schema*.

## Schema

### Preview Schema

| Property    | Type/Format      | Description                                                  |
| ----------- | ---------------- | ------------------------------------------------------------ |
| html        | string           | A block of HTML to display as the preview. This is HTML received from the provider's oEmbed server and represents the provider's preference when rendering a link preview. We recommend placing this HTML within an iframe to minimize the security risk from third-party JavaScript. |
| publisher   | string           | The name of the publisher, ex: *Twitter*.                    |
| favicon     | string/uri       | The publisher favicon. **Important:** this is not the same as the image associated with the content or the publisher *logo*, which some providers include. We want the highest resolution version (ex: 64x64). |
| title       | string           | The title of the content.                                    |
| author      | string           | The author of the content.                                   |
| published   | string/date-time | The publish date in ISO-8601 format.                         |
| description | string           | The description of the content.                              |
| url         | string/uri       | The canonical URL of the link, providing an authoritative reference to this resource. |
| media       | object           | An object describing any associated media. See [Media Schema](#media-schema). |

### Media Schema

| Property | Type/Format  | Description                                                  |
| -------- | ------------ | ------------------------------------------------------------ |
| images   | array/object | An array of image descriptions. See [Image Schema](#image-schema). |
| audio    | array/object | An array of audio descriptions. See [Video/Audio Schema](#video--audio-schema). |
| videos   | array/object | An array of video descriptions. See [Video/Audio Schema](#video—audio-schema). |
| players  | array/object | An array of media player descriptions. See [Player Schema](#player-schema). |

### Image Schema

| Property | Type/Format  | Description                                                  |
| -------- | ------------ | ------------------------------------------------------------ |
| caption  | string       | Description of image or alternate text.                      |
| url      | string/uri   | URL for fallback image.                                      |
| formats  | array/object | A list of images specified by their mediatype and URL. We recommend arranging these in a [`picture`][picture] element to allow the client to select the optimal format for the circumstance. See [Format Schema](#format-schema). |

### Video / Audio Schema

| Property | Type/Format  | Description                                                  |
| -------- | ------------ | ------------------------------------------------------------ |
| formats  | array/object | A list of media specifying their mediatype and URL. We recommend arranging these in [`video`][video] or [`audio`][audio] elements to allow the client to select the optimal format for the circumstance. See [Format Schema](#format-schema). |

### Format Schema

| Property | Type/Format | Description                 |
| -------- | ----------- | --------------------------- |
| format   | string      | The mediatype of the media. |
| url      | string/uri  | The URL for the media.      |

### Player Schema

| Property | Type/Format | Description                                                  |
| -------- | ----------- | ------------------------------------------------------------ |
| html     | string      | The HTML for a custom player as specified by the provider's oEmbed server.  This represents the provider's preference when rendering preview media.  We recommend placing this HTML within an iframe to minimize the security risk from third-party JavaScript. |

[picture]: https://developer.mozilla.org/en-US/docs/Learn/HTML/Multimedia_and_embedding/Responsive_images#Use_modern_image_formats_boldly
[audio]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/audio
[video]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/video
[encoded-uri]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/encodeURI
