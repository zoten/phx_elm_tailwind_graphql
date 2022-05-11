defmodule ScmpWeb.Resolvers.Accounts.Club do
  @moduledoc """
  GraphQL resolvers for Club entities
  """

  def list_clubs(_parent, _args, _resolution) do
    # IO.inspect([parent, args, Map.keys(resolution)])
    {:ok, Scmp.Clubs.all()}
  end
end
