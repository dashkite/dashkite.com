## Browser Clients

### Carbon

[Carbon][] wraps the WebComponents API in a functional-programming-styled interface that simplifies managing a component's lifecycle. Uses the efficient [diffHTML algorithm][] to update the DOM and[constructable stylesheets][] to encapsulate style concerns.

### Quark

[Quark][] provides a functional interface to build up Cascading Style Sheets from JavaScript. Quark keeps everything portable and easy to reason about by using just JS to generate just CSS. As this library matures, it will lay the foundation for presets and theming that are more sophisticated than DSL implementations, like Stylus, and use less bandwidth than heavy style libraries, like Bootstrap.

### Oxygen

[Oxygen][] provides an interface for routing page requests based on URL templates. Provides a dispatch hook that merely takes a function, so routes can do anything, so it is flexible and widely compatible.

### Neon

[Neon][] provides a functional interface for updating views within a single page app. Since the sync/async composition returns a function, Neon is easily used with Oxygen or any other routing solution that accepts a function.

  [Carbon]: //github.com/dashkite/carbon
  [diffHTML algorithm]: //github.com/tbranyen/diffhtml
  [constructable stylesheets]: https://wicg.github.io/construct-stylesheets/
  [Quark]: https://github.com/dashkite/quark
  [Oxygen]: https://github.com/dashkite/oxygen
  [Neon]: https://github.com/dashkite/neon
