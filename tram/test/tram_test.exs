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
    assert {:doors_open, _} = Tram.get_status()
  end

  test "Incorrect state transition is not implemented by mistake" do
    start_supervised(Tram)
    pid = GenServer.whereis(Tram)
    ref = Process.monitor(pid)
    Tram.move()

    assert_receive {:DOWN, ^ref, :process, ^pid, reason}
    assert {:function_clause, _} = reason
  end
end
