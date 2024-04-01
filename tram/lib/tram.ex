defmodule Tram do
  @moduledoc """
  Tram state machine
                                  ↓
  :moving ⇄ :doors_closed ⇄ :doors_open

  While standing it let passengers in and out
  """
  use GenServer

  # Client

  def start_link(passengers \\ []) when is_list(passengers) do
    GenServer.start_link(__MODULE__, passengers, name: __MODULE__)
  end

  def move, do: GenServer.cast(__MODULE__, :move)

  def stop, do: GenServer.cast(__MODULE__, :stop)

  def open_doors, do: GenServer.cast(__MODULE__, :open_doors)

  def close_doors, do: GenServer.cast(__MODULE__, :close_doors)

  def swap_passengers(going_in, going_out) when is_list(going_in) and is_list(going_in) do
    GenServer.cast(__MODULE__, {:swap_passengers, going_in, going_out})
  end

  def get_status do
    GenServer.call(__MODULE__, :status)
  end

  # Server (callbacks)

  @impl GenServer
  def init(passengers) do
    passengers = MapSet.new(passengers)
    initial_state = {:doors_open, passengers}
    {:ok, initial_state}
  end

  @impl GenServer
  def handle_cast(:move, {:moving, passengers}), do: {:noreply, {:moving, passengers}}

  @impl GenServer
  def handle_cast(:move, {:doors_closed, passengers}), do: {:noreply, {:moving, passengers}}

  @impl GenServer
  def handle_cast(:open_doors, {:doors_open, passengers}),
    do: {:noreply, {:doors_open, passengers}}

  @impl GenServer
  def handle_cast(:open_doors, {:doors_closed, passengers}),
    do: {:noreply, {:doors_open, passengers}}

  @impl GenServer
  def handle_cast(:stop, {:doors_open, passengers}), do: {:noreply, {:doors_open, passengers}}

  @impl GenServer
  def handle_cast(:stop, {:doors_closed, passengers}), do: {:noreply, {:doors_closed, passengers}}

  @impl GenServer
  def handle_cast(:stop, {:moving, passengers}), do: {:noreply, {:doors_closed, passengers}}

  @impl GenServer
  def handle_cast(:close_doors, {:doors_closed, passengers}),
    do: {:noreply, {:doors_closed, passengers}}

  @impl GenServer
  def handle_cast(:close_doors, {:moving, passengers}), do: {:noreply, {:moving, passengers}}

  @impl GenServer
  def handle_cast(:close_doors, {:doors_open, passengers}),
    do: {:noreply, {:doors_closed, passengers}}

  @impl GenServer
  def handle_cast({:swap_passengers, going_in, going_out}, {:doors_open, passengers}) do
    passengers =
      passengers
      |> MapSet.union(MapSet.new(going_in))
      |> MapSet.difference(MapSet.new(going_out))

    {:noreply, {:doors_open, passengers}}
  end

  @impl GenServer
  def handle_call(:status, _from, state) do
    {:reply, state, state}
  end
end
