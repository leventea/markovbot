defmodule TelegramBot.Stage.UpdateProducer do
  use GenStage

  # CLIENT API

  def start_link(opts \\ []) do
    GenStage.start_link(__MODULE__, :ok, opts)
  end

  def push_update(update) when is_struct(update) do
    GenStage.cast(__MODULE__, {:push, [update]})
  end

  def push_updates(updates) when is_list(updates) do
    GenStage.cast(__MODULE__, {:push, updates})
  end

  # SERVER API

  def init(:ok) do
    {:producer, :ok, dispatcher: GenStage.BroadcastDispatcher }
  end

  def handle_cast({:push, updates}, _state) do
    {:noreply, updates, :ok} # instantly buffer/dispatch updates
  end

  def handle_demand(_demand, _state) do
    {:noreply, [], :ok} # ignore demands
  end
end
