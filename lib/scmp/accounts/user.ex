defmodule Scmp.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

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
    |> validate_required([:name, :groups, :metadata])
  end
end
