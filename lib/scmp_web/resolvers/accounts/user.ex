defmodule ScmpWeb.Resolvers.Accounts.User do
  @moduledoc """
  GraphQL resolvers for User entities
  """

  def find_user(_parent, %{id: id}, _resolution) do
    case Scmp.Accounts.get_user(id) do
      {:error, :not_found} ->
        {:error, "User ID #{id} not found"}

      {:ok, user} ->
        {:ok, user}
    end
  end

  def create_user(_parent, %{name: name} = _args, _resolution) do
    Scmp.Accounts.create_user(%{name: name})
  end
end
