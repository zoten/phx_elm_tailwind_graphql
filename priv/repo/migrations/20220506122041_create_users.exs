defmodule Scmp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :groups, :string
      add :metadata, :map

      timestamps()
    end

    create table(:users_clubs) do
      add :user_id, references(:users)
      add :club_id, references(:clubs)
    end

    create unique_index(:users_clubs, [:user_id, :club_id])
  end
end
