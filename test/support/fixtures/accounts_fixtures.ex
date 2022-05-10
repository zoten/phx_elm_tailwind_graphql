defmodule Scmp.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Scmp.Accounts` context.
  """

  @doc """
  Generate a club.
  """
  def club_fixture(attrs \\ %{}) do
    {:ok, club} =
      attrs
      |> Enum.into(%{
        metadata: %{},
        name: "some name"
      })
      |> Scmp.Accounts.create_club()

    club
  end

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        groups: "some groups",
        metadata: %{},
        name: "some name"
      })
      |> Scmp.Accounts.create_user()

    user
  end
end
