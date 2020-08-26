import Registry from "@dashkite/helium"
import _configuration from "./configuration.yaml"

configuration = _configuration[process.env.NODE_ENV]

Registry.set "configuration:breeze": configuration.breeze

export default configuration
