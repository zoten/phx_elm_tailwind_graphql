defmodule Scmp.Accounts.UsersClubs do
  use Ecto.Schema
  import Ecto.Changeset
  # import Ecto.Query, only: [from: 2]
  # import Ecto, only: [assoc: 2]

  alias Scmp.Repo
  alias __MODULE__

  schema "users_clubs" do
    belongs_to :club, Scmp.Accounts.Club
    belongs_to :user, Scmp.Accounts.User
  end

  @type t :: %UsersClubs{}

  def add(club_id, user_id) do
    IO.inspect([club_id, user_id])

    %UsersClubs{}
    |> changeset(%{club_id: club_id, user_id: user_id})
    |> Repo.insert()
  end

  @doc false
  def changeset(user_club, attrs) do
    user_club
    |> cast(attrs, [:club_id, :user_id])
    |> validate_required([:club_id, :user_id])
  end
end
