defmodule Scam.Repo.Migrations.CreateConversationParts do
  use Ecto.Migration

  def change do
    create table(:conversation_parts) do
      add :author, :string
      add :content, :text

      timestamps()
    end
  end
end
