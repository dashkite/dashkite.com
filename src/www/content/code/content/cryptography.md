## Cryptography

### Confidential

Cryptography is tricky, and dealing with low-level details can compromise whole applications. Fortunately the [TweetNaCL.js library][] wraps the Web Crypto and Node Crypto APIs and handles cryptographic primitives. [Confidential][] adds a usability layer to make cryptographic tasks high-level and easier to reason about.

### Cobalt

Using the safety of the Confidential interface, we built [Cobalt], an implementation of Web capabilities, bearer credentials that describe an HTTP request that the claimant is allowed to make. It's an incredibly powerful distributed authorization scheme with favorable properties for Web apps.

### Zinc

Building on the foundation for Cobalt, [Zinc][] makes it easy to use Web Capabilities within the browser. Zinc also generates persistent keypairs that can be used to sign them and support client-side encryption. We plan to integrate Zinc with the WebAuthn authentication standard.

  [TweetNaCL.js library]: //tweetnacl.js.org/
  [Confidential]: //confidential.pandastrike.com/
  [Cobalt]: //github.com/dashkite/cobalt
  [Zinc]: //github.com/dashkite/zinc
