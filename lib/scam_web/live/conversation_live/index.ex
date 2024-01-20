defmodule ScamWeb.ConversationLive.Index do
  use ScamWeb, :live_view
  alias Scam.Accounts
  alias Scam.AddictionCheck
  alias Scam.AddictionCheck.ConversationPart

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :messages, [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:ok, user} = case params do
      %{"id" => id} -> Accounts.get_user!(id)
      _ -> Accounts.create_user(%{
        name: "not_provided",
        surname: "not_provided",
        date_of_birth: Date.utc_today(),
        city: "not_provided",
        postal_code: "not_provided",
        address_line_one: "not_provided",
        country: "not_provided",
        phone_number: "not_provided",
      })
    end
    new_socket = assign(socket, :id, user.id)
    {:noreply, apply_action(new_socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Conversations")
    |> assign(:messages, case socket.assigns.id do
      nil -> []
      _ -> AddictionCheck.list_conversation_parts(%{ client_id: socket.assigns.id })
    end)
  end

  def handle_event("get_user_id", %{}, socket) do
#    push event with user id
    {:noreply, push_event(socket, "user_id", %{user_id: socket.assigns.id})}
  end



  defp handle_client_message(message, socket) do
    client_id = socket.assigns.id
    IO.inspect client_id
    {:ok, client_conversation} = AddictionCheck.create_conversation_part(%{author: :user, content: message, client_id: client_id})
    socket = stream_insert(socket, :messages, client_conversation)
    conversations = AddictionCheck.list_conversation_parts(%{ client_id: client_id })
    messages =  [
                  %{role: "system", content: "Jesteś asystentem, który ma pomóc użytkownikowi w walce z uzależnieniem i wykryć u niego uzależnienie."},
                ] ++ Enum.map(conversations, fn conversation -> case conversation.author do
                                                                  :user -> %{role: "user", content: conversation.content}
                                                                  :bot -> %{role: "assistant", content: conversation.content}
                                                                  :expert -> %{role: "assistant", content: conversation.content}
                                                                end end)

    chatbot_response = OpenAI.chat_completion(
      model: "gpt-3.5-turbo",
      messages: messages,
    )

    chatbot_response_text = case chatbot_response do
      {:ok, response} -> response.choices.at(0).message.content
      _ -> "Nie rozumiem, proszę spróbuj wytłumaczyć inaczej"
    end

    chatbot_conversation_part = %{author: :bot, content: chatbot_response_text, client_id: client_id}

    {:ok, chatbot_conversation_part} = AddictionCheck.create_conversation_part(chatbot_conversation_part)

    {:noreply, push_event(stream_insert(socket, :messages, chatbot_conversation_part), "clear_message_input", %{})}
  end

  @impl true
  def handle_event("client_message", %{"key" => "Enter", "value" => message}, socket) do
    handle_client_message(message, assign(socket, :message, nil))
  end

  @impl true
  def handle_event("client_message", %{"key" => key, "value" => value}, socket) do
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
