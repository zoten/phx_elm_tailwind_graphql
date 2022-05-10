defmodule Scmp.Repo.Migrations.CreateClubs do
  use Ecto.Migration

  def change do
    create table(:clubs) do
      add :name, :string
      add :metadata, :map

      timestamps()
    end
  end
end
