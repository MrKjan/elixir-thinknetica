defmodule Pingpong.Server do
  @moduledoc """
  Example of a simple pingpong server using genserver with sync and async calls
  """
  def start_link do
    GenServer.start_link(__MODULE__, nil)
  end

  def sync_heavy_work(pid) do
    GenServer.cast(pid, {:heavy_work, self()})

    receive do
      {:heavy_work, result} -> do_handle_result(result)
    end
  end

  def do_handle_result(_) do
    IO.puts("sync_heavy_work/1 finished")
  end

  def async_heavy_work(pid) do
    GenServer.cast(pid, :heavy_work)
    IO.puts("async_heavy_work/1 finished")
  end

  @impl GenServer
  def init(nil) do
    {:ok, :genserver_up}
  end

  @impl GenServer
  def handle_cast({:heavy_work, pid}, state) do
    handle_cast(:heavy_work, state)
    |> tap(fn {_, new_state} -> send(pid, {:heavy_work, new_state}) end)
  end

  def handle_cast(:heavy_work, state) do
    state = do_heavy_work(state)
    {:noreply, state}
  end

  def do_heavy_work(_state) do
    :timer.sleep(5_000)
    IO.puts("do_heavy_work/1 finished")
  end
end
