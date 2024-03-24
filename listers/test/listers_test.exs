defmodule ListersTest do
  use ExUnit.Case
  doctest Listers

  test "greets the world" do
    assert Listers.hello() == :world
  end
end
