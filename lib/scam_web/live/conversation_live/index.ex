defmodule ScamWeb.ConversationLive.Index do
  use ScamWeb, :live_view
  alias Scam.Accounts
  alias Scam.AddictionCheck
  alias Scam.AddictionCheck.ConversationPart

  @impl true
  def mount(params, session, socket) do
    {:ok, socket |> stream(:messages, [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end


  defp apply_action(socket, :index, _params) do
    list = case socket.assigns[:id] do
      nil -> []
      _ -> AddictionCheck.list_conversation_parts(%{ client_id: socket.assigns.id })
    end

    socket = Enum.reduce(list, socket, fn conversation, acc ->
      stream_insert(acc, :messages, conversation)
    end)
    socket
    |> assign(:page_title, "Listing Conversations")
  end

  def handle_event("get_user_id", %{}, socket) do
#    push event with user id
    {:noreply, push_event(socket, "received_user_id", %{user_id: socket.assigns.id})}
  end

  @impl true
  def handle_event("create_user", %{}, socket) do
    {:ok, user} = Accounts.create_user(%{
      name: "not_provided",
      surname: "not_provided",
      date_of_birth: Date.utc_today(),
      city: "not_provided",
      postal_code: "not_provided",
      address_line_one: "not_provided",
      country: "not_provided",
      phone_number: "not_provided",
    })
    {:noreply, push_event(assign(socket, :id, user.id), "user_id", %{user_id: user.id})}
  end

  def handle_event("set_user_id", %{"user_id" => user_id}, socket) do
    user = Accounts.get_user!(user_id)
    messages = AddictionCheck.list_conversation_parts(%{ client_id: user.id })
    socket = Enum.reduce(messages, socket, fn conversation, acc ->
      stream_insert(acc, :messages, conversation)
    end)
    {:noreply, assign(socket, :id, user.id)}
  end


  defp handle_client_message(message, socket) do
    client_id = socket.assigns.id
    {:ok, client_conversation} = AddictionCheck.create_conversation_part(%{author: :user, content: message, client_id: client_id})
    socket = stream_insert(socket, :messages, client_conversation)
    conversations = AddictionCheck.list_conversation_parts(%{ client_id: client_id })
    messages =   Enum.map(conversations, fn conversation -> case conversation.author do
                                                                  :user -> %{role: "user", content: conversation.content}
                                                                  :bot -> %{role: "assistant", content: conversation.content}
                                                                  :expert -> %{role: "assistant", content: conversation.content}
                                                                end end)

    chatbot_response = OpenAI.chat_completion(
      model: "gpt-3.5-turbo",
      messages: [
                  %{role: "system", content: "Jesteś asystentem, który ma pomóc użytkownikowi w walce z uzależnieniem i wykryć u niego uzależnienie."},
                ] ++ Enum.take(messages, -10),
    )

    chatbot_response_text = case chatbot_response do
      {:ok, response} -> Enum.at(response.choices, 0)["message"]["content"]
      _ -> "Nie rozumiem, proszę spróbuj wytłumaczyć inaczej"
    end

    chatbot_conversation_part = %{author: :bot, content: chatbot_response_text, client_id: client_id}

    {:ok, chatbot_conversation_part} = AddictionCheck.create_conversation_part(chatbot_conversation_part)

    {:noreply, stream_insert(socket, :messages, chatbot_conversation_part)}
  end

  @impl true
  def handle_event("client_message", %{"key" => "Enter", "value" => message}, socket) do
    handle_client_message(message, assign(socket, :message, nil))
  end

  @impl true
  def handle_event("client_message", %{"key" => _key, "value" => value}, socket) do
#    assign value to socket message
    {:noreply, assign(socket, :message, value)}
  end

  @impl true
  def handle_event("confirm_client_message", _, socket) do
    message = socket.assigns.message
    case message do
      nil -> {:noreply, socket}
      _ -> handle_client_message(message, assign(socket, :message, nil))
    end
  end

#  Should create new user
#  @impl true
#  def handle_event("create_conv", %{
#    "name" => name,
#    "surname" => surname,
#
#  }, socket) do
#
#  end
end
