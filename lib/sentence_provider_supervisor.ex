defmodule SentenceProvider.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, [], opts)
  end

  def init(_args) do
    children = [
      { SentenceProvider, name: SentenceProvider }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
