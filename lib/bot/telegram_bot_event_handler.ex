defmodule TelegramBot.EventHandler do
  import TelegramBot.Helpers
  import TelegramBot.CommandHandler

  def handle_update(update) do
    msg = update.message

    if has_valid_msg(update) do
      dispatch_update(update, msg)
    end
  end

  defp dispatch_update(_update, msg) do
    admin = msg.from.id in [532217020]

    cmd = parse_command(msg)
    cond do
      cmd != nil -> handle_command(cmd, msg, admin)
      true -> handle_message(msg)
    end
  end

  def handle_message(msg) do
    # H.reply(message, "hello")
  end
end
