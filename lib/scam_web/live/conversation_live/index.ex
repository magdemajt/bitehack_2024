defmodule ScamWeb.ConversationLive.Index do
  use ScamWeb, :live_view

  alias Scam.AddictionCheck
  alias Scam.AddictionCheck.Conversation

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :conversations, AddictionCheck.list_conversations())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Conversation")
    |> assign(:conversation, AddictionCheck.get_conversation!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Conversation")
    |> assign(:conversation, %Conversation{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Conversations")
    |> assign(:conversation, nil)
  end

  @impl true
  def handle_info({ScamWeb.ConversationLive.FormComponent, {:saved, conversation}}, socket) do
    {:noreply, stream_insert(socket, :conversations, conversation)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    conversation = AddictionCheck.get_conversation!(id)
    {:ok, _} = AddictionCheck.delete_conversation(conversation)

    {:noreply, stream_delete(socket, :conversations, conversation)}
  end

  @impl true
  def handle_event("client_message", %{"client_id" => client_id, "message" => message}, socket) do
    conversation = AddictionCheck.get_conversation!(client_id)
#    zip conversation.questions, conversation.answers and then map to OpenAI messages

    zipped_conv =Enum.zip(conversation.questions, conversation.answers)
                 |> Enum.flat_map(fn {q, a} -> [%{role: "assistant", content: a}] ++ [%{role: "user", content: q}]  end)

    messages =  [
      %{role: "system", content: "Jesteś asystentem, który ma pomóc użytkownikowi w walce z uzależnieniem i wykryć u niego uzależnienie."},
    ] ++ zipped_conv

    chatbot_response = OpenAI.chat_completion(
      model: "gpt-3.5-turbo",
      messages: [
        %{role: "system", content: "Jesteś asystentem, który ma pomóc użytkownikowi w walce z uzależnieniem i wykryć u niego uzależnienie."},
      ] ++ zipped_conv
    )

    {:noreply, stream_update(socket, :conversations, conversation)}
  end

  @impl true
  def handle_event("create_conv", %{"client_id" => client_id}, socket) do
    conversation = %Conversation{client_id: client_id, questions: [], answers: []}
    {:ok, _} = AddictionCheck.create_conversation(conversation)

    {:noreply, stream_insert(socket, :conversations, conversation)}
  end

#  Should create new user
  @impl true
  def handle_event("create_conv", %{
    "name" => name,
    "surname" => surname,

  }, socket) do

  end
end
