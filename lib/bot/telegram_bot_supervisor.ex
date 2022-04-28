defmodule TelegramBot.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, [], opts)
  end

  def init(_args) do
    children = [
      { TelegramBot.Stage.UpdateProducer, name: TelegramBot.Stage.UpdateProducer },
      { TelegramBot.EventPoller, "my name jeff" },

      { TelegramBot.Stage.UpdateConsumer, name: TelegramBot.Stage.UpdateConsumer }
    ]

    Supervisor.init(children, strategy: :rest_for_one)
  end
end
