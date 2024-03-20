defmodule PingpongTest do
  use ExUnit.Case
  doctest Pingpong

  test "server pongs" do
    server_pid = spawn(Pingpong, :server, [])
    send(server_pid, {:ping, self()})
    receive do
      response -> assert({:pong, _node} = response)
    after
      # obviously its a clutch
      1_000 ->
        assert(false, "test time limit exceeded")
    end
    Process.exit(server_pid, :time_to_die)
  end
end
