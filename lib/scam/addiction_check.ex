defmodule Scam.AddictionCheck do
  @moduledoc """
  The AddictionCheck context.
  """

  import Ecto.Query, warn: false
  alias Scam.Repo

  alias Scam.AddictionCheck.ConversationPart

  @doc """
  Returns the list of conversation_parts.

  ## Examples

      iex> list_conversation_parts()
      [%ConversationPart{}, ...]

  """
  def list_conversation_parts do
    Repo.all(ConversationPart)
  end

  def list_conversation_parts(%{ "client_id" => client_id }) do
#    sort by created_at
    Repo.all(ConversationPart, where: [client_id: client_id], order_by: [asc: :inserted_at])
  end

  def list_conversation_parts(_rest) do
    #    sort by created_at
    Repo.all(ConversationPart, order_by: [asc: :inserted_at])
  end

  @doc """
  Gets a single conversation_part.

  Raises `Ecto.NoResultsError` if the Conversation part does not exist.

  ## Examples

      iex> get_conversation_part!(123)
      %ConversationPart{}

      iex> get_conversation_part!(456)
      ** (Ecto.NoResultsError)

  """
  def get_conversation_part!(id), do: Repo.get!(ConversationPart, id)

  @doc """
  Creates a conversation_part.

  ## Examples

      iex> create_conversation_part(%{field: value})
      {:ok, %ConversationPart{}}

      iex> create_conversation_part(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_conversation_part(attrs \\ %{}) do
    %ConversationPart{}
    |> ConversationPart.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a conversation_part.

  ## Examples

      iex> update_conversation_part(conversation_part, %{field: new_value})
      {:ok, %ConversationPart{}}

      iex> update_conversation_part(conversation_part, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_conversation_part(%ConversationPart{} = conversation_part, attrs) do
    conversation_part
    |> ConversationPart.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a conversation_part.

  ## Examples

      iex> delete_conversation_part(conversation_part)
      {:ok, %ConversationPart{}}

      iex> delete_conversation_part(conversation_part)
      {:error, %Ecto.Changeset{}}

  """
  def delete_conversation_part(%ConversationPart{} = conversation_part) do
    Repo.delete(conversation_part)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking conversation_part changes.

  ## Examples

      iex> change_conversation_part(conversation_part)
      %Ecto.Changeset{data: %ConversationPart{}}

  """
  def change_conversation_part(%ConversationPart{} = conversation_part, attrs \\ %{}) do
    ConversationPart.changeset(conversation_part, attrs)
  end
end
