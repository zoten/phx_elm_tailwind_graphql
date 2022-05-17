defmodule ScmpWeb.Resolvers.Accounts.Club do
  @moduledoc """
  GraphQL resolvers for Club entities
  """

  def list_clubs(_parent, _args, _resolution) do
    # IO.inspect([parent, args, Map.keys(resolution)])
    {:ok, Scmp.Clubs.all()}
  end

  def find_club(_parent, %{id: id}, _resolution) do
    case Scmp.Accounts.get_club(id) do
      {:error, :not_found} ->
        {:error, "Club ID #{id} not found"}

      {:ok, club} ->
        {:ok, club}
    end
  end

  def create_club(_parent, %{name: name} = _args, _resolution) do
    Scmp.Accounts.create_club(%{name: name})
  end

  def add_user(_parent, %{club_id: club_id, user_id: user_id} = _args, _resolution) do
    case Scmp.Accounts.add_user_to_club(club_id, user_id) do
      :ok -> {:ok, %{outcome: true}}
      error -> error
    end
  end

  def delete_user(_parent, %{club_id: club_id, user_id: user_id} = _args, _resolution) do
    case Scmp.Accounts.delete_user_from_club(club_id, user_id) do
      :ok -> {:ok, %{outcome: true}}
      error -> error
    end
  end
end
