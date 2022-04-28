defmodule MarkovBotTest do
  use ExUnit.Case
  doctest MarkovBot

  test "greets the world" do
    assert MarkovBot.hello() == :world
  end
end
