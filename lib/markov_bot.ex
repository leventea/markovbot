defmodule MarkovBot do
  use Application

  def start(_type, _args) do
    MarkovBot.Supervisor.start_link()
  end
end
