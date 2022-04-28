defmodule TelegramBot.EventHandler do
  alias TelegramBot.Helpers, as: H

  def handle_update(update) do
    handle_message(update.message)
  end

  def handle_message(message) do
    H.reply(message, "hello")
  end
end
