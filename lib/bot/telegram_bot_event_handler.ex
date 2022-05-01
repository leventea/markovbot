defmodule TelegramBot.EventHandler do
  import TelegramBot.Helpers
  import TelegramBot.CommandHandler

  import Application, only: [ get_env: 2 ]

  def handle_update(update) do
    msg = update.message

    cond do
      has_valid_msg(update) ->
        dispatch_update(update, msg)
      get_env(:markov_bot, :log_ignored) and update.edited_message == nil ->
        IO.puts "ignored message from chat: #{update.message.chat.id}, user: #{update.message.from.id}"
      true -> nil
    end

    if has_valid_msg(update) do
      dispatch_update(update, msg)
    else

    end
  end

  defp dispatch_update(_update, msg) do
    admin = msg.from.id in Application.get_env(:markov_bot, :admins)

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
    if guaranteed_reply?(msg) or Enum.random(1..100) < 10 do
      {:ok, response} = SentenceProvider.generate_sentence(SentenceProvider)
      reply(msg, response)
    end
  end
end
