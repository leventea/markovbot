defmodule MarkovBot do
  use Application

  def start(_type, _args) do
    SentenceProvider.Supervisor.start_link(name: SentenceProvider.Supervisor)
    TelegramBot.Supervisor.start_link(name: TelegramBot.Supervisor)
  end
end
