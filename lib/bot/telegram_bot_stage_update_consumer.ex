defmodule TelegramBot.Stage.UpdateConsumer do
  use GenStage

  alias TelegramBot.EventHandler, as: Handler

  def start_link(opts \\ []) do
    GenStage.start_link(__MODULE__, :ok, opts)
  end

  def init(_args) do
    # NOTE: state does not matter here
    {:consumer, [], subscribe_to: [ {TelegramBot.Stage.UpdateProducer, max_demand: 20, min_demand: 1} ]}
  end

  def handle_events(events, _from, _state) do
    Enum.each(events, fn up -> Handler.handle_update(up) end)

    {:noreply, [], []}
  end
end
