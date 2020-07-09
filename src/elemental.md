## Elementals: Open Web APIs

### Carbon

[Carbon][] wraps the WebComponents API in a functional-programming-styled interface that simplifies managing a component's lifecycle. Uses the efficient [diffHTML algorithm][diffHTML] to update the DOM and[constructable stylesheets](https://wicg.github.io/construct-stylesheets/) to encapsulate style concerns.

### Quark

[Quark](https://github.com/dashkite/quark) provides a functional interface to build up Cascading Style Sheets from JavaScript. Quark keeps everything portable and easy to reason about by using just JS to generate just CSS. As this library matures, it will lay the foundation for presets and theming that are more sophisticated than DSL implementations, like Stylus, and use less bandwidth than heavy style libraries, like Bootstrap.

### Oxygen

[Oxygen](https://github.com/dashkite/oxygen) provides an interface for routing page requests based on URL templates. Provides a dispatch hook that merely takes a function, so routes can do anything, so it is flexible and widely compatible.

### Neon

[Neon](https://github.com/dashkite/neon) provides a functional interface for updating views within a single page app. Since the sync/async composition returns a function, Neon is easily used with Oxygen or any other routing solution that accepts a function.

[Carbon]://github.com/dashkite/carbon
[diffHTML]://github.com/tbranyen/diffhtml
