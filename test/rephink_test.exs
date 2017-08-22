defmodule RephinkTest do
  use ExUnit.Case
  doctest Rephink

  test "greets the world" do
    assert Rephink.hello() == :world
  end
end
