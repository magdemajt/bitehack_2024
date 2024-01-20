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

  describe "conversation_parts" do
    alias Scam.AddictionCheck.ConversationPart

    import Scam.AddictionCheckFixtures

    @invalid_attrs %{author: nil, content: nil}

    test "list_conversation_parts/0 returns all conversation_parts" do
      conversation_part = conversation_part_fixture()
      assert AddictionCheck.list_conversation_parts() == [conversation_part]
    end

    test "get_conversation_part!/1 returns the conversation_part with given id" do
      conversation_part = conversation_part_fixture()
      assert AddictionCheck.get_conversation_part!(conversation_part.id) == conversation_part
    end

    test "create_conversation_part/1 with valid data creates a conversation_part" do
      valid_attrs = %{author: :user, content: "some content"}

      assert {:ok, %ConversationPart{} = conversation_part} = AddictionCheck.create_conversation_part(valid_attrs)
      assert conversation_part.author == :user
      assert conversation_part.content == "some content"
    end

    test "create_conversation_part/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = AddictionCheck.create_conversation_part(@invalid_attrs)
    end

    test "update_conversation_part/2 with valid data updates the conversation_part" do
      conversation_part = conversation_part_fixture()
      update_attrs = %{author: :bot, content: "some updated content"}

      assert {:ok, %ConversationPart{} = conversation_part} = AddictionCheck.update_conversation_part(conversation_part, update_attrs)
      assert conversation_part.author == :bot
      assert conversation_part.content == "some updated content"
    end

    test "update_conversation_part/2 with invalid data returns error changeset" do
      conversation_part = conversation_part_fixture()
      assert {:error, %Ecto.Changeset{}} = AddictionCheck.update_conversation_part(conversation_part, @invalid_attrs)
      assert conversation_part == AddictionCheck.get_conversation_part!(conversation_part.id)
    end

    test "delete_conversation_part/1 deletes the conversation_part" do
      conversation_part = conversation_part_fixture()
      assert {:ok, %ConversationPart{}} = AddictionCheck.delete_conversation_part(conversation_part)
      assert_raise Ecto.NoResultsError, fn -> AddictionCheck.get_conversation_part!(conversation_part.id) end
    end

    test "change_conversation_part/1 returns a conversation_part changeset" do
      conversation_part = conversation_part_fixture()
      assert %Ecto.Changeset{} = AddictionCheck.change_conversation_part(conversation_part)
    end
  end
end
