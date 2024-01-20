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
    {:ok, user} = case params.id do
      nil -> Accounts.create_user(%{
        name: "not_provided",
        surname: "not_provided",
        date_of_birth: "not_provided",
        city: "not_provided",
        postal_code: "not_provided",
        address_line_one: "not_provided",
        country: "not_provided",
        phone_number: "not_provided",
      })
      id -> Accounts.get_user!(id)
    end
    new_socket = assign(socket, :id, user.id)
    {:noreply, apply_action(new_socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Conversations")
    |> assign(:messages, [])
  end



  @impl true
  def handle_event("client_message", %{"client_id" => client_id, "value" => message}, socket) do
    client_conversation_part = %ConversationPart{author: :user, content: message, client_id: client_id}
    {:ok, _} = AddictionCheck.create_conversation_part(client_conversation_part)
    conversations = AddictionCheck.list_conversation_parts(%{ client_id: client_id })
    messages =  [
      %{role: "system", content: "Jesteś asystentem, który ma pomóc użytkownikowi w walce z uzależnieniem i wykryć u niego uzależnienie."},
    ] ++ Enum.map(conversations, fn conversation -> case conversation.author do
      :user -> %{role: "user", content: conversation.question}
      :bot -> %{role: "assistant", content: conversation.answer}
      :expert -> %{role: "assistant", content: conversation.answer}
    end end)

    chatbot_response = OpenAI.chat_completion(
      model: "gpt-3.5-turbo",
      messages: messages,
    )

    chatbot_response_text = case chatbot_response do
      {:ok, response} -> response.choices.at(0).message.content
      _ -> "Nie rozumiem, proszę spróbuj wytłumaczyć inaczej"
    end

    chatbot_conversation_part = %ConversationPart{author: :bot, content: chatbot_response_text, client_id: client_id}

    {:ok, _} = AddictionCheck.create_conversation_part(chatbot_conversation_part)

    conversation_parts_with_chatbot = AddictionCheck.list_conversation_parts(%{ client_id: client_id })

    {:noreply, stream_insert(socket, :messages, conversation_parts_with_chatbot)}
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
