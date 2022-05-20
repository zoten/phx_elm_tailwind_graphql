defmodule Scmp.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  import Ecto, only: [assoc: 2]

  alias Scmp.Repo
  alias __MODULE__

  schema "users" do
    # Just to avoid having another many_to_many thing in place, we will fake it
    # by keeping a space-separated list of groups, if needed
    field :groups, :string
    field :metadata, :map
    field :name, :string

    many_to_many :clubs, Scmp.Accounts.Club, join_through: "users_clubs"

    timestamps()
  end

  @moduledoc """
  Get all Users
  """
  def all(opts \\ []) do
    order_by = Keyword.get(opts, :order_by, :name)

    query =
      from u in User,
        order_by: ^order_by

    Repo.all(query)
  end

  @doc false
  def count_users(id) do
    # Could be a direct query on users_clubs but have to find how
    # to express it better in ecto
    User |> Repo.get(id) |> assoc(:clubs) |> Repo.aggregate(:count, :id)
  end

  def get_by_id(id) do
    case Repo.get(User, id) do
      nil -> {:error, :not_found}
      %User{} = user -> {:ok, user}
    end
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :groups, :metadata])
    |> validate_required([:name])
  end
end
