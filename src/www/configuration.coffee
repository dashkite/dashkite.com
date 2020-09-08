import Registry from "@dashkite/helium"
import _configuration from "./configuration.yaml"

configuration = _configuration[process.env.NODE_ENV]

export default configuration
