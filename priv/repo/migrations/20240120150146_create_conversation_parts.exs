defmodule Scam.Repo.Migrations.CreateConversationParts do
  use Ecto.Migration

  def change do
    create table(:conversation_parts) do
      add :author, :string
      add :content, :text
      add :client_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:conversation_parts, [:client_id])
  end
end
