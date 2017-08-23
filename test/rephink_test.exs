defmodule RephinkTest do
  use ExUnit.Case, async: true
  use Plug.Test
  doctest Rephink

  test "greets the world" do
    assert Rephink.hello() == :world
  end

  test "the truth" do
    assert 1 + 1 == 2
  end
end
