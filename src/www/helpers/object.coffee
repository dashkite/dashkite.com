import {curry, binary} from "@pandastrike/garden"
import Generics from "panda-generics"

isString = (value) -> value.constructor == String
isArray = (value) -> Array.isArray value
isObject = (value) -> value instanceof Object

get = Generics.create
  name: "get"
  description: "Get property from an object
    with the property name or array of names"

Generics.define get, isString, isObject, (key, object) -> object[key]

Generics.define get, isArray, isObject, (keys, object) ->
  for key in keys
    object = object[key]
  object

get = curry binary get

export {get}
