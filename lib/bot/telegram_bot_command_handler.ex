defmodule TelegramBot.CommandHandler do
  import TelegramBot.Helpers

  alias SentenceProvider, as: SP
  alias TelegramExportParser, as: EP

  def handle_command(cmd, msg, admin \\ false)

  def handle_command("links", msg, _admin) do
    {:ok, count} = SentenceProvider.link_count(SentenceProvider)

    reply(msg, "the markov chain contains #{count} links")
  end

  def handle_command(cmd, _msg, _admin) do
    IO.puts("unknown / unauthorized for: #{cmd}")
  end
end
