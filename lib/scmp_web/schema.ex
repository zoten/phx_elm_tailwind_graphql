defmodule Scmp.Schema do
  use Absinthe.Schema

  import_types(Scmp.Schema.AccountTypes)

  query do
    @desc "Get a list of all clubs"
    field :clubs, list_of(:club) do
      resolve(&ScmpWeb.Resolvers.Accounts.Club.list_clubs/3)
    end

    @desc "Get a user"
    field :user, :user do
      arg(:id, non_null(:id))
      resolve(&ScmpWeb.Resolvers.Accounts.User.find_user/3)
    end
  end

  # The context/1 function is a callback specified by the Absinthe.Schema
  # behaviour that gives the schema itself an opportunity to set some values
  # in the context that it may need in order to run.
  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(User, ScmpWeb.Contexts.User.data())

    # # Foo source could be a Redis source
    # |> Dataloader.add_source(Foo, Foo.data())

    Map.put(ctx, :loader, loader)
  end

  # The plugins/0 function has been around for a while, and specifies what plugins
  # the schema needs to resolve.
  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end