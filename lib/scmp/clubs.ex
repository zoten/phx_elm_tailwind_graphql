defmodule Scmp.Clubs do
  @moduledoc """
  Business logic for clubs
  """

  alias Scmp.Accounts.Club
  # alias __MODULE__

  @doc """
  Get all clubs

  opts
   * ...
  """
  @spec all(keyword) :: list(Club.t())
  def all(opts \\ []) do
    # order_by = Keyword.get(opts, :order_by, :name)
    Club.all(opts)
  end

  @spec count_users(integer()) :: {:ok, integer()}
  def count_users(id) do
    {:ok, Club.count_users(id)}
  end
end
