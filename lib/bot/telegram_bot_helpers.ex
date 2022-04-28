defmodule TelegramBot.Helpers do
  alias Nadia, as: N

  def reply(message, text, opts \\ []) do
    chat_id = message.chat.id

    N.send_message(chat_id, text, opts)
  end

end
