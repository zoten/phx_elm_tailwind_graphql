# Scmp

Sport Club Management Platform

Showcase to see how Elixir+Phoenix, Elm, GraphQL and TailwindCSS may (opinionately) stick together

## Disclaimer

This is not for any production use.

## Changes until now

[See also](https://hexdocs.pm/phoenix/asset_management.html#content)

 - 
    ``` bash
    cd assets
    npm install esbuild --save-dev
    npm install esbuild-plugin-elm --save-dev

    npm install ../deps/phoenix ../deps/phoenix_html ../deps/phoenix_live_view --save
    ```

 -
   ``` elixir
   # config.exs

   # Comment out esbuild config
   # config :esbuild,
   ```
  
 - Create [`assets/build.json`](./assets/build.json)
 - Create [`assets/src/Main.elm`](./assets/src/Main.elm)

 -
   ``` elixir
   # dev.exs

   config :phx_elm, PhxElmWeb.Endpoint,
    # ...
    watchers: [
      # Start the esbuild watcher by calling Esbuild.install_and_run(:default, args)
      # esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]}
      node: ["build.js", "--watch", cd: Path.expand("../assets", __DIR__)]
    ]
   ```
  
  - `assets/`
    ``` bash
    elm init
    # this should create elm.json file
    ```

  - `app.js`
    Maybe the less convincing part, it needs to require Elm and bind the application
    to a dom element

    ``` javascript
    import { Elm } from '../src/Main.elm';
    /* ... */
    const $root = document.createElement('div');
    document.body.appendChild($root);
    Elm.Main.init({
      node: $root
    });

    ```

  - Steps are (see [commit](https://github.com/zoten/phx_elm_tailwind_graphql/commit/a1c01d1cee61e75c4662b4ac1065f1d92bdc4af0)):
    - Add to [`mix.exs`](./mix.exs) the tailwind dependency
      ``` elixir
      # ...
      {:tailwind, "~> 0.1", runtime: Mix.env() == :dev},
      ```
    - Add tailwind imports to [`assets/css/app.css`](./assets/css/app.css)
    - Remove phoenix.css and comment out its own classes from [`assets/css/app.css`](./assets/css/app.css)
    - Remove app.css import from [`assets/js/app.js`](./assets/js/app.js)
    - Add [`assets/tailwind.config.js`](./assets/tailwind.config.js) (probably optional if you configure accordingly)
    - Configure tailwind in [`config/config.exs`](./config/config.exs)
    - Configure watchers in [`config/dev.exs`](./config/dev.exs) for development
    - use CSS in layout or wherever is needed, as in [lib/scmp_web/templates/layout/root.html.heex](lib/scmp_web/templates/layout/root.html.heex)