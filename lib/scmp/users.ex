defmodule Scmp.Users do
  @moduledoc """
  Business logic for clubs
  """

  alias Scmp.Accounts.User
  # alias __MODULE__

  @doc """
  Get all users

  opts
   * ...
  """
  @spec all(keyword) :: list(User.t())
  def all(opts \\ []) do
    # order_by = Keyword.get(opts, :order_by, :name)
    User.all(opts)
  end

  @spec count_clubs(integer()) :: {:ok, integer()}
  def count_clubs(id) do
    {:ok, User.count_users(id)}
  end
end
