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
end
