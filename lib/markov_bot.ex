defmodule MarkovBot do
  use Application

  def start(_type, _args) do
    {:ok, main_sup} = MarkovBot.Supervisor.start_link()

    # load the previous chain state auto-save
    chain_path = Path.absname("./state.chain")
    if File.exists?(chain_path) do
      SentenceProvider.load_state(SentenceProvider, chain_path)
    end

    {:ok, main_sup}
  end
end
