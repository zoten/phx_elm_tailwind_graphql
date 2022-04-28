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

