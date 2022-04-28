defmodule TelegramBot.CommandHandler do
  import TelegramBot.Helpers

  def handle_command("ping", msg) do
    reply(msg, "pong")
  end

  def handle_command(cmd, _msg) do
    IO.puts("unknown command #{cmd}")
  end
end
