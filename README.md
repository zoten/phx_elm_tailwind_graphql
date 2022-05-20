# Scmp

Sport Club Management Platform

Showcase to see how Elixir+Phoenix, Elm, GraphQL and TailwindCSS may (opinionately) stick together

## Disclaimer

 * This is not for any use if not "oh, this two-lines code snippet is what I need"
 * I know really few about build pipelines for the modern web. There are surely way better ways to do the frontend stitching
 * dev port is hardcoded to 4000. This number is hardcoded in the web app and in some dev scripts. Forwarding of this port's configuration is left as an exercise to the reader (aka I'm lazy and this is out of scope, please free your port 4000 before running stuff here :) )
 * This stuff is not following any good practice (architectural, code separation, contexts, boundaries etc). Just meant to show stuff.
 * No error handling, unless I was testing error handling on some resource/case

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
iex -S mix phx.server
```

### Re-Generate APIs

With the dev server running on port 4000, run

``` bash
npm run generate:api
```

## Milestones

Since this is an example project, there are a few notable milestones in building it that are identified by tags

 - Step 1 [phoenix_elm](https://github.com/zoten/phx_elm_tailwind_graphql/releases/tag/phoenix_elm): simply have a phoenix application that serves an Elm counter
 - Step 2 [phoenix_elm_tailwind ](https://github.com/zoten/phx_elm_tailwind_graphql/releases/tag/phoenix_elm_tailwind): add a super basic tailwind support
 - Step 3 [phoenix_elm_tailwind_sass](https://github.com/zoten/phx_elm_tailwind_graphql/releases/tag/phoenix_elm_tailwind_sass ): add a SASS precompilation step before tailwind, to support more powerful semantics (e.g. nested styles)

## Notable Changes

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
    require Elm and bind the application to a dom element

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

## Useful GraphQL queries

Examples to test in graphiql (at http://localhost:4000/graphiql) or to load/check data

### Query

#### Fetch clubs information

``` graphql
{
  clubs {
    id
    name
    usersCount
  }
}
```

#### Fetch club information

``` graphql
{
  club(id:2){
    name,
    users
  }
}
```

### Mutations

#### Create Club

``` graphql
mutation CreateClub {
  createClub(name: "Club5") {
    id
    name
  }
}
```

#### Create User

``` graphql
mutation CreateUser {
  createUser(name: "User19") {
    id
    name
  }
}
```

#### Add User to club via id

``` graphql
mutation AddUserToClub {
  addUserToClub(club_id: 1, user_id: 3) {
    outcome
  }
}
```

#### Delete User from club via id

``` graphql
mutation DeleteUserFromClub {
  deleteUserFromClub(club_id: 4, user_id: 3) {
    outcome
  }
}
```

## TODO

 - [ ] check if production build is working 😶
 - [ ] get rid of self generated assets/css/app.css file 🤨
 - [ ] modularize "hand-crafted" and repeated tailwind class chains
 - [x] "extract" a base layout
   - [ ] do it well
 - [x] check that the final css is stripped (not MB of unused stuff :) )
