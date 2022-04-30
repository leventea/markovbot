defmodule MarkovBot.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, [], opts ++ [name: MarkovBot.Supervisor])
  end

  def init(_args) do
    children = [
      { SentenceProvider.Supervisor, name: SentenceProvider.Supervisor },
      { TelegramBot.Supervisor, name: TelegramBot.Supervisor }
    ]

    Supervisor.init(children, strategy: :rest_for_one)
  end
end
