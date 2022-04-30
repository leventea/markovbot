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
    admin = msg.from.id in [532217020, 1741227329] # TODO: don't hardcode

    cmd = parse_command(msg)
    cond do
      cmd == :invalid -> nil # do nothing
      cmd != nil -> handle_command(cmd, msg, admin)
      true -> handle_message(msg)
    end
  end

  def handle_message(msg) do
    SentenceProvider.train(SentenceProvider, [ msg.text ])

    # randomly reply to the message
    # NOTE: should probably use config files for this
    if Enum.random(1..100) < 25 do
      {:ok, response} = SentenceProvider.generate_sentence(SentenceProvider)
      reply(msg, response)
    end
  end
end
