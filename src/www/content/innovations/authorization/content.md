DashKite’s security model provides a solution for least-privilege distributed authorization for the Open Web. This eliminates a major class of security vulnerabilities and provides a path toward federated authorization for modern Web applications. Such applications increasingly encompass desktop, tablet, mobile, and other devices. Our approach thus has the potential to significantly improve privacy and security for billions of people around the world who use and rely on the Web every day.

Existing best practices for distributed authorization rely on privileged access to private data. For example, a photo sharing app needs to know whether a photo belongs to you before granting your request to update or delete it. An attacker can exploit this access by crafting requests that confuse or fool the application. Federated authorization based on this approach necessarily exacerbates such vulnerabilities, since each provider needs access to private data.

This is hardly a theoretical concern. For example, in 2018, [hackers gained access to 30 million Facebook accounts][1] by finding a code path in which Facebook servers returned access authentication for the wrong identity. Those tokens may have also allowed hackers to access third-party sites that relied on Facebook for authentication.

In contrast, capability-based authorization does not rely on privileged access to data, so it’s resistant to privilege escalation attacks, and thus also more amenable to federation. For example, a photo sharing app would grant you the capability to update or delete the photo when you first upload it. The decision to issue the grant is based entirely on the fact that you were the one who uploaded it. Moreover, this grant is publicly verifiable, meaning authorization can be delegated to a minimally trusted intermediary, making federated authorization considerably safer.

While research into capability security for distributed authorization is underway, these efforts have either been limited in scope or have neglected critical requirements for Web applications.

In contrast, our approach:

- Specifies capabilities entirely in terms of HTTP, eliminating the need for policy and constraint languages.
- Naturally extends the state transfer design of HTTP, leveraging the massive investment in existing Web infrastructure.
- Can be put rapidly into practice by millions of developers who already build Web applications.
- Supports critial features, such as durable grants, key rotation, and sub-millisecond zero-trust verification.

We first set out to demonstrate that capability security for Web applications was feasible. Over the past two years, we've built simple testbed applications to prove this and to improve our implementation, which [we published as an open source library][2].



[1]: https://blog.qualys.com/news/2018/10/01/hackers-exploit-facebook-bug-as-twitter-dms-maybe-got-misrouted
[2]: https://github.com/dashkite/cobalt
