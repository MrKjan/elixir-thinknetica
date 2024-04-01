defmodule TramTest do
  use ExUnit.Case
  doctest Tram

  test "Passengers load" do
    {:ok, _pid} = Tram.start_link()
    Tram.swap_passengers([:aa, :bb, :cc], [:pp, :qq])
    Tram.swap_passengers([:pp, :dd], [:pp, :qq, :aa])
    assert {:doors_open, MapSet.new([:cc, :bb, :dd])} == Tram.get_status()
  end

  test "Correct state transition" do
    {:ok, _pid} = Tram.start_link()
    Tram.close_doors()
    Tram.move()
    Tram.move()
    Tram.stop()
    Tram.open_doors()
  end

  test "Incorrect state transition" do
    start_link_supervised!(Tram)
    Tram.move()
    # Tram.get_status(pid)
    # :timer.sleep(100)
  end
end
