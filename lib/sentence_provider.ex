defmodule SentenceProvider do
  use GenServer

  alias Markov, as: M
  import List

  # CLIENT API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def train(pid, list) when is_list(list) do
    GenServer.call(pid, {:train_from_list, list})
  end

  def flush(pid) do
    GenServer.cast(pid, {:flush_chain})
  end

  def generate_sentence(pid) do
    GenServer.call(pid, {:generate_sentence})
  end
  
  # SERVER API

  @impl true
  def init(_chain) do
    {:ok, %M{}}
  end

  @impl true
  def handle_cast({:flush_chain}, _chain) do
    {:noreply, %M{}}
  end

  @impl true
  def handle_call({:train_from_list, list}, _caller, state_chain) when is_list(list) do
    new_chain = foldr(list, state_chain, fn i, chain ->
      M.train(chain, i)
    end)

    {:reply, :ok, new_chain}
   end

  @impl true
  def handle_call({:generate_sentence}, _caller, state_chain) do
    {:reply, {:ok, M.generate_text(state_chain)}, state_chain}
  end

end
