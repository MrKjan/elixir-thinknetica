defmodule BullsAndCowsTest do
  use ExUnit.Case
  doctest BullsAndCows

  test "greets the world" do
    assert BullsAndCows.hello() == :world
  end
end
