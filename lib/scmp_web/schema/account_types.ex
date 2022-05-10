defmodule Scmp.Schema.AccountTypes do
  @moduledoc false
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  # GraphQL "object type"
  object :club do
    # Field: a bit of queriable information
    field :name, :string
    field :users, list_of(:user), resolve: dataloader(User)
  end

  object :user do
    field :name, :string
  end
end
