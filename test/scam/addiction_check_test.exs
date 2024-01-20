defmodule Scam.AddictionCheckTest do
  use Scam.DataCase

  alias Scam.AddictionCheck

  describe "conversations" do
    alias Scam.AddictionCheck.Conversation

    import Scam.AddictionCheckFixtures

    @invalid_attrs %{questions: nil, answers: nil}

    test "list_conversations/0 returns all conversations" do
      conversation = conversation_fixture()
      assert AddictionCheck.list_conversations() == [conversation]
    end

    test "get_conversation!/1 returns the conversation with given id" do
      conversation = conversation_fixture()
      assert AddictionCheck.get_conversation!(conversation.id) == conversation
    end

    test "create_conversation/1 with valid data creates a conversation" do
      valid_attrs = %{questions: ["option1", "option2"], answers: ["option1", "option2"]}

      assert {:ok, %Conversation{} = conversation} = AddictionCheck.create_conversation(valid_attrs)
      assert conversation.questions == ["option1", "option2"]
      assert conversation.answers == ["option1", "option2"]
    end

    test "create_conversation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = AddictionCheck.create_conversation(@invalid_attrs)
    end

    test "update_conversation/2 with valid data updates the conversation" do
      conversation = conversation_fixture()
      update_attrs = %{questions: ["option1"], answers: ["option1"]}

      assert {:ok, %Conversation{} = conversation} = AddictionCheck.update_conversation(conversation, update_attrs)
      assert conversation.questions == ["option1"]
      assert conversation.answers == ["option1"]
    end

    test "update_conversation/2 with invalid data returns error changeset" do
      conversation = conversation_fixture()
      assert {:error, %Ecto.Changeset{}} = AddictionCheck.update_conversation(conversation, @invalid_attrs)
      assert conversation == AddictionCheck.get_conversation!(conversation.id)
    end

    test "delete_conversation/1 deletes the conversation" do
      conversation = conversation_fixture()
      assert {:ok, %Conversation{}} = AddictionCheck.delete_conversation(conversation)
      assert_raise Ecto.NoResultsError, fn -> AddictionCheck.get_conversation!(conversation.id) end
    end

    test "change_conversation/1 returns a conversation changeset" do
      conversation = conversation_fixture()
      assert %Ecto.Changeset{} = AddictionCheck.change_conversation(conversation)
    end
  end
end
