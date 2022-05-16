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
end
