defmodule Scmp.Accounts.Club do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias Scmp.Repo
  alias __MODULE__

  schema "clubs" do
    field :metadata, :map
    field :name, :string

    many_to_many :users, Scmp.Accounts.User, join_through: "users_clubs"

    timestamps()
  end

  @moduledoc """
  Get all Clubs
  """
  def all(opts \\ []) do
    order_by = Keyword.get(opts, :order_by, :name)

    query =
      from c in Club,
        order_by: ^order_by

    Repo.all(query)
  end

  @doc false
  def changeset(club, attrs) do
    club
    |> cast(attrs, [:name, :metadata])
    |> validate_required([:name, :metadata])
  end
end
