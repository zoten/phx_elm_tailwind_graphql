defmodule Scmp.Accounts.Club do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  import Ecto, only: [assoc: 2]

  alias Scmp.Repo
  alias __MODULE__

  schema "clubs" do
    field :metadata, :map
    field :name, :string

    many_to_many :users, Scmp.Accounts.User, join_through: "users_clubs"

    timestamps()
  end

  @type t :: %Club{}

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
    |> validate_required([:name])
  end

  @doc false
  def count_users(id) do
    # Could be a direct query on users_clubs but have to find how
    # to express it better in ecto
    Club |> Repo.get(id) |> assoc(:users) |> Repo.aggregate(:count, :id)
  end

  @doc false
  def get_by_id(id) do
    case Repo.get(Club, id) do
      nil -> {:error, :not_found}
      %Club{} = club -> {:ok, club}
    end
  end
end
