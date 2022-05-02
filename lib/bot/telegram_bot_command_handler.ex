defmodule TelegramBot.CommandHandler do
  import TelegramBot.Helpers

  def handle_command(cmd, msg, admin \\ false)

  def handle_command("links", msg, _admin) do
    {:ok, count} = SentenceProvider.link_count(SentenceProvider)

    reply(msg, "the markov chain contains #{count} links")
  end

  def handle_command(cmd, _msg, _admin) do
    if Application.get_env(:markov_bot, :log_ignored) do
      IO.puts("unknown / unauthorized for: #{cmd}")
    end
  end
end
