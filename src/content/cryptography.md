## Cryptography

### Confidential

Cryptography is tricky, and dealing with low-level details can compromise whole applications. Fortunately the [TweetNaCL.js library][] wraps the Web Crypto and Node Crypto APIs and handles cryptographic primitives. [Confidential][] adds a usability layer to make cryptographic tasks high-level and easier to reason about.

### Cobalt

Using the safety of the Confidential interface, we built [Cobalt], an implementation of Web capabilities, bearer credentials that describe an HTTP request that the claimant is allowed to make. It's an incredibly powerful distributed authorization scheme with favorable properties for Web apps.

  [TweetNaCL.js library]: //tweetnacl.js.org/#/
  [Confidential]: //confidential.pandastrike.com/
  [Cobalt]: //github.com/dashkite/cobalt
