defmodule PingpongTest do
  use ExUnit.Case
  doctest Pingpong

  test "server pongs" do
    server_pid = spawn(Pingpong, :server, [])
    send(server_pid, {:ping, self()})
    assert_receive({:pong, _node})
    Process.exit(server_pid, :time_to_die)
  end
end
