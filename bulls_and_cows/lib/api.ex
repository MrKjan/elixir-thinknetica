defmodule BullsAndCows.API do
  alias BullsAndCows
  use GenServer

  # Client

  @doc """
    Make number to guess to be picked, start the game
  """
  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  @doc """
    Guess the number
  """
  def make_turn(pid, answer) do
    GenServer.call(pid, {:make_turn, answer})
  end

  # Server (callbacks)

  @impl true
  def init(_) do
    initial_state = BullsAndCows.new_game()
    {:ok, initial_state}
  end

  @impl true
  def handle_call({:make_turn, answer}, _from, state) do
    %BullsAndCows{moves: moves, win: is_win} = new_state = BullsAndCows.make_turn(state, answer)
    {:reply, %{moves: moves, win: is_win}, new_state}
  end
end
