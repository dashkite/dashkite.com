import Registry from "@dashkite/helium"
import _configuration from "./configuration.yaml"

console.log "loading configuration:", process.env.NODE_ENV
configuration = _configuration[process.env.NODE_ENV]

export default configuration
