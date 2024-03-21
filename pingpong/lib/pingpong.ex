defmodule Pingpong do
  @moduledoc """
  Example of a simple pingpong server
  """

  @doc """
  Runs pingpong server
  """
  def server do
    receive do
      {:ping, pid} ->
        send(pid, {:pong, node()})
        server()
    end
  end
end
