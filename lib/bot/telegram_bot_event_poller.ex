defmodule TelegramBot.EventPoller do
  use Task

  alias TelegramBot.Stage.UpdateProducer
  alias Nadia, as: N

  def start_link(_args) do
    Task.start_link(__MODULE__, :run, [ 0 ])
  end

  def run(offset \\ 0) do
    {:ok, updates} = N.get_updates(timeout: 60, offset: offset)

    latest = List.last(updates)
    new_offset = if latest != nil do
      UpdateProducer.push_updates(updates)

      latest.update_id + 1
    else offset end

    run(new_offset)
  end

end
