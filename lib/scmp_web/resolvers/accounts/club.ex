defmodule ScmpWeb.Resolvers.Accounts.Club do
  @moduledoc """
  GraphQL resolvers for Club entities
  """

  def list_clubs(parent, args, resolution) do
    IO.inspect([parent, args, Map.keys(resolution)])
    {:ok, Scmp.Clubs.all()}
  end
end
