import Registry from "@dashkite/helium"
import Router from "@dashkite/oxygen"

router = Router.create()
Registry.set {router}

export {router}
