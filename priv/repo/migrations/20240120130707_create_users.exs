defmodule Scam.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :surname, :string
      add :date_of_birth, :date
      add :city, :string
      add :postal_code, :string
      add :address_line_one, :string
      add :country, :string
      add :phone_number, :string

      timestamps()
    end
  end
end
