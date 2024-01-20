defmodule Scam.AddictionCheck.ConversationPart do
  use Ecto.Schema
  import Ecto.Changeset

  schema "conversation_parts" do
    field :author, Ecto.Enum, values: [:user, :bot, :expert]
    field :content, :string
    field :client_id, :id

    timestamps()
  end

  @doc false
  def changeset(conversation_part, attrs) do
    conversation_part
    |> cast(attrs, [:author, :content])
    |> validate_required([:author, :content])
  end
end
