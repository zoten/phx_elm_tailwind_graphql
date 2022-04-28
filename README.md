# Scmp

Sport Club Management Platform

Showcase to see how Elixir+Phoenix, Elm, GraphQL and TailwindCSS may (opinionately) stick together

## Disclaimer

 * This is not for any production use.
 * I know really few about build pipelines for the modern web. There are surely way better ways to do the frontend stitching

### Opinionated disclaimer

I usually try to avoid having frontend and backend for the same application on the same repo.

 * I find it difficult to work on the repo itself when team competences/tasks are split
   * unrelated commits mix up
   * people may find difficult to work _on old_ or _without new_ APIs without having to rebase their own stuff, duplicating repo or whatever
   * people may mix up frontend and backend commits, making conflict resolution harder
 * Unrelated tools stack up on the same application, making difficult to bootstrap it
   * e.g. I only work on the GraphQL endpoint, why should I bother installing node/yarn/elm/tailwind/...

However, there are cases where the DX is actually faster and/or the product iteration is better

 * You already know and accept you will have only __one__ version of the API in production (e.g. only one version of the product exists)
   * This is for me a _sine qua non_ condition
 * The team horizontal competences spread and everyone tends to work on everything
 * The team is disciplined in how it manages commits, separation of work and concerns, and review is a common practice

Said that, this project is about this cases where you accept challenges and limitations of a mono-repo fullstack approach :)

## Run

### Dev

``` bash
./start-compose-dev.sh
mix setup
iex -S phx.server
```

## Changes until now

[See also](https://hexdocs.pm/phoenix/asset_management.html#content)
[See also](https://pragmaticstudio.com/tutorials/adding-tailwind-css-to-phoenix)

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

  - Add TailwindCSS basic support via Elixir official support module
    Steps are (see [commit](https://github.com/zoten/phx_elm_tailwind_graphql/commit/a1c01d1cee61e75c4662b4ac1065f1d92bdc4af0)):
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
  
  - Add DartSass support (to support nested styles) [source post](https://pragmaticstudio.com/tutorials/adding-tailwind-css-to-phoenix)
    - Make the CSS creation a two step pipeline (SASS + Tailwind)
    - Unluckily, need to add a `mix setup` call before first run, otherwise a needed file will not be found
