defmodule ScmpWeb.Schema.AccountTypes do
  @moduledoc false
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]
  import_types(Absinthe.Type.Custom)

  # GraphQL "object type"
  object :club do
    # Field: a bit of queriable information
    field :id, :id
    field :name, :string
    field :users, list_of(:user), resolve: dataloader(User)
  end

  object :user do
    field :id, :id
    field :name, :string
    field :inserted_at, :naive_datetime
  end
end
