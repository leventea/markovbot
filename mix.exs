defmodule MarkovBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :markov_bot,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :jason],
      mod: {MarkovBot, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.3"},
      {:markov, "~> 1.2"},
      {:nadia, "~> 0.7"},
      {:gen_stage, "~> 1.1"},
      {:quantum, "~> 3.4"}
    ]
  end
end
