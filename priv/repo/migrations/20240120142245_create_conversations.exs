defmodule Scam.Repo.Migrations.CreateConversations do
  use Ecto.Migration

  def change do
    create table(:conversations) do
      add :questions, {:array, :string}
      add :answers, {:array, :string}
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:conversations, [:user_id])
  end
end
