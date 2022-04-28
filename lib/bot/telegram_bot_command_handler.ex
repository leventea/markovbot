defmodule TelegramBot.CommandHandler do
  import TelegramBot.Helpers

  alias SentenceProvider, as: SP
  alias TelegramExportParser, as: EP

  def handle_command("ping", msg) do
    reply(msg, "pong")
  end

  def handle_command(cmd, msg, admin \\ false)

  def handle_command("id", msg, _admin) do
    reply(msg, "your id: #{msg.from.id}")
  end

  def handle_command("chat_id", msg, _admin) do
    reply(msg, "chat id: #{msg.chat.id}")
  end

  def handle_command("is_admin", msg, admin) do
    reply(msg, "#{admin}")
  end

  def handle_command("funny", msg, _admin) do
    {:ok, sentence} = SP.generate_sentence(SP)
    reply(msg, sentence)
  end

  def handle_command("chain_flush", _msg, true) do
    SP.flush(SP)
  end

  def handle_command("chain_reload", msg, true) do
    msgs = EP.get_messages(Path.absname('./export.json'))
    SP.train(SP, msgs)

    reply(msg, "ok")
  end

  def handle_command(cmd, _msg, _admin) do
    IO.puts("unknown / unauthorized for: #{cmd}")
  end
end
