defmodule ScmpWeb.Schema.AccountTypes do
  @moduledoc false
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]
  import_types(Absinthe.Type.Custom)

  alias Scmp.Clubs
  alias Scmp.Users
  # GraphQL "object type"
  object :club do
    # Field: a bit of queriable information
    field :id, :id
    field :name, :string
    field :users, list_of(:user), resolve: dataloader(User)

    field :users_count, :integer,
      resolve: fn parent, _field, _resolution ->
        # parent is a %Scmp.Accounts.Club{} struct here
        Clubs.count_users(parent.id)
      end
  end

  object :user do
    field :id, :id
    field :name, :string

    field :clubs, list_of(:club), resolve: dataloader(Club)

    field :inserted_at, :naive_datetime

    field :clubs_count, :integer,
      resolve: fn parent, _field, _resolution ->
        # parent is a %Scmp.Accounts.Club{} struct here
        Users.count_clubs(parent.id)
      end
  end

  object :add_user_to_club_response do
    field :outcome, :boolean
  end

  object :delete_user_from_club_response do
    field :outcome, :boolean
  end
end
