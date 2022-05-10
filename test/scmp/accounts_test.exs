defmodule Scmp.AccountsTest do
  use Scmp.DataCase

  alias Scmp.Accounts

  describe "users" do
    alias Scmp.Accounts.Club

    import Scmp.AccountsFixtures

    @invalid_attrs %{metadata: nil, name: nil}

    test "list_users/0 returns all users" do
      club = club_fixture()
      assert Accounts.list_users() == [club]
    end

    test "get_club!/1 returns the club with given id" do
      club = club_fixture()
      assert Accounts.get_club!(club.id) == club
    end

    test "create_club/1 with valid data creates a club" do
      valid_attrs = %{metadata: %{}, name: "some name"}

      assert {:ok, %Club{} = club} = Accounts.create_club(valid_attrs)
      assert club.metadata == %{}
      assert club.name == "some name"
    end

    test "create_club/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_club(@invalid_attrs)
    end

    test "update_club/2 with valid data updates the club" do
      club = club_fixture()
      update_attrs = %{metadata: %{}, name: "some updated name"}

      assert {:ok, %Club{} = club} = Accounts.update_club(club, update_attrs)
      assert club.metadata == %{}
      assert club.name == "some updated name"
    end

    test "update_club/2 with invalid data returns error changeset" do
      club = club_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_club(club, @invalid_attrs)
      assert club == Accounts.get_club!(club.id)
    end

    test "delete_club/1 deletes the club" do
      club = club_fixture()
      assert {:ok, %Club{}} = Accounts.delete_club(club)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_club!(club.id) end
    end

    test "change_club/1 returns a club changeset" do
      club = club_fixture()
      assert %Ecto.Changeset{} = Accounts.change_club(club)
    end
  end

  describe "clubs" do
    alias Scmp.Accounts.Club

    import Scmp.AccountsFixtures

    @invalid_attrs %{metadata: nil, name: nil}

    test "list_clubs/0 returns all clubs" do
      club = club_fixture()
      assert Accounts.list_clubs() == [club]
    end

    test "get_club!/1 returns the club with given id" do
      club = club_fixture()
      assert Accounts.get_club!(club.id) == club
    end

    test "create_club/1 with valid data creates a club" do
      valid_attrs = %{metadata: %{}, name: "some name"}

      assert {:ok, %Club{} = club} = Accounts.create_club(valid_attrs)
      assert club.metadata == %{}
      assert club.name == "some name"
    end

    test "create_club/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_club(@invalid_attrs)
    end

    test "update_club/2 with valid data updates the club" do
      club = club_fixture()
      update_attrs = %{metadata: %{}, name: "some updated name"}

      assert {:ok, %Club{} = club} = Accounts.update_club(club, update_attrs)
      assert club.metadata == %{}
      assert club.name == "some updated name"
    end

    test "update_club/2 with invalid data returns error changeset" do
      club = club_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_club(club, @invalid_attrs)
      assert club == Accounts.get_club!(club.id)
    end

    test "delete_club/1 deletes the club" do
      club = club_fixture()
      assert {:ok, %Club{}} = Accounts.delete_club(club)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_club!(club.id) end
    end

    test "change_club/1 returns a club changeset" do
      club = club_fixture()
      assert %Ecto.Changeset{} = Accounts.change_club(club)
    end
  end

  describe "users" do
    alias Scmp.Accounts.User

    import Scmp.AccountsFixtures

    @invalid_attrs %{groups: nil, metadata: nil, name: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{groups: "some groups", metadata: %{}, name: "some name"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.groups == "some groups"
      assert user.metadata == %{}
      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{groups: "some updated groups", metadata: %{}, name: "some updated name"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.groups == "some updated groups"
      assert user.metadata == %{}
      assert user.name == "some updated name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
