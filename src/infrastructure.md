## Infrastructure

### Haiku9

[Haiku9][] lets you publish static sites and single page apps from the command-line. Assets are stored in S3, and CloudFront is used to handle your serving needs. Edge lambdas can be used to optimize caching efficiency and perform server(less)-side rendering.

In fact, this site is served to you from such a deployment.

### Panda Sky

[Panda Sky][] lets you publish serverless infrastructure from the command-line, just like you can publish static assets with Haiku9. Provides a lambda with custom HTTP dispatching and fine-grained permissions to Cloud resources, all fronted by a optimized CloudFront edge cache and WAF firewall.

[Haiku9]://github.com/pandastrike/haiku9
[Panda Sky]://github.com/pandastrike/panda-sky
