defmodule Scam.AddictionCheckFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Scam.AddictionCheck` context.
  """

  @doc """
  Generate a conversation.
  """
  def conversation_fixture(attrs \\ %{}) do
    {:ok, conversation} =
      attrs
      |> Enum.into(%{
        answers: ["option1", "option2"],
        questions: ["option1", "option2"]
      })
      |> Scam.AddictionCheck.create_conversation()

    conversation
  end

  @doc """
  Generate a conversation_part.
  """
  def conversation_part_fixture(attrs \\ %{}) do
    {:ok, conversation_part} =
      attrs
      |> Enum.into(%{
        author: :user,
        content: "some content"
      })
      |> Scam.AddictionCheck.create_conversation_part()

    conversation_part
  end
end
