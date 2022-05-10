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
  def all(opts \\ []) do
    # order_by = Keyword.get(opts, :order_by, :name)
    Club.all(opts)
  end
end
