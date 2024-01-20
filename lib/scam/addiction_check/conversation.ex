defmodule Scam.AddictionCheck.Conversation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "conversations" do
    field :questions, {:array, :string}
    field :answers, {:array, :string}
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:questions, :answers])
    |> validate_required([:questions, :answers])
  end
end
