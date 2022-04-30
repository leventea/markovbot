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

  def save_state(pid, path) do
    GenServer.call(pid, {:save_state, path})
  end

  def load_state(pid, path) do
    GenServer.call(pid, {:load_state, path})
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

  @impl true
  def handle_call({:save_state, path}, _caller, state_chain) do
    bin = :erlang.term_to_binary(state_chain)

    case File.write(path, bin, [ :binary ]) do
      :ok -> { :reply, :ok, state_chain }
      err -> { :reply, err, state_chain }
    end
  end

  @impl true
  def handle_call({:load_state, path}, _caller, state_chain) do
    case File.read(path) do
      # NOTE: you are not going to have a good time if it reads anything else than its own output
      { :ok, binary } ->
        chain = :erlang.binary_to_term(binary)
        { :reply, :ok, chain }
      err -> { :reply, err, state_chain } # doesn't modify state on failure
    end
  end
end
