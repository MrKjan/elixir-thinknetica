defmodule BullsAndCows do
  use Accessible

  @moduledoc """
  A game of bulls and cows, rules:
  You need to guess 4 different numbers in definite order.
  If number is correct but in wrong position, its a cow, if value and position is correct, its a bull.

  Game should be played in iex. First you init game by new_game/0,
  then you should pass state to make_turn/2 until you win

  Game example:
  $ game = BullsAndCows.new_game()
  %BullsAndCows{number_encrypted: "ೞ", seed: 314, moves: [], win: false}
  """

  @seed_range 500

  defstruct number_encrypted: [],
            seed: 0,
            moves: [],
            win: false

  @doc """
  Returns game state
  """
  def new_game() do
    number = generate_number_list()
    seed = Enum.random(0..@seed_range)

    %__MODULE__{
      number_encrypted: encrypt(number),
      seed: seed,
      moves: [],
      win: false
    }
  end

  @doc """
  Updates state with your answer, checks win conditions

  ## Examples

      iex> BullsAndCows.make_turn(%BullsAndCows{number_encrypted: "ೞ", seed: 314, moves: [], win: false}, 1234)
      %BullsAndCows{
        number_encrypted: "ೞ",
        seed: 314,
        moves: [%{answer: 1234, bulls: 0, cows: 1}],
        win: false
      }

      iex> BullsAndCows.make_turn(%BullsAndCows{number_encrypted: "ڊ", seed: 411, moves: [%{answer: 1263, bulls: 4, cows: 0}], win: true}, 8888)
      %{win: true, moves_cnt: 1}

  """
  def make_turn(%__MODULE__{win: true, moves: moves}, _turn),
    do: %{win: true, moves_cnt: length(moves)}

  def make_turn(state, answer) do
    %{bulls: bulls, cows: cows} =
      check_turn(
        decrypt(state[:number_encrypted], state[:seed]),
        Integer.digits(answer)
      )

    %{
      state
      | moves: [%{answer: answer, bulls: bulls, cows: cows} | state[:moves]],
        win: 4 == bulls
    }
  end

  @doc """
  Checks count of bulls and cows in answer

  ## Examples

      iex> BullsAndCows.check_turn([1,2,3,4], [0,2,3,1])
      %{bulls: 2, cows: 1}

  """
  def check_turn(riddle, answer), do: check_turn(riddle, answer, 0, 0)
  def check_turn(_riddle, [], bulls, cows), do: %{bulls: bulls, cows: cows}

  def check_turn(riddle, [head | tail], bulls, cows) do
    cond do
      head == elem(List.to_tuple(riddle), 3 - length(tail)) ->
        check_turn(riddle, tail, bulls + 1, cows)

      head in riddle ->
        check_turn(riddle, tail, bulls, cows + 1)

      true ->
        check_turn(riddle, tail, bulls, cows)
    end
  end

  @doc """
    Returns array like [0,1,2,3]
  """
  def generate_number_list(), do: generate_number_list([])
  def generate_number_list(number_list) when 4 == length(number_list), do: number_list

  def generate_number_list(number_list) do
    digit = Enum.random(0..9)

    # I do not want to overcomplicate
    if Enum.member?(number_list, digit) do
      generate_number_list(number_list)
    else
      generate_number_list([digit | number_list])
    end
  end

  @doc """
  ## Examples

      iex> BullsAndCows.encrypt([0,1,2,3], 2)
      "}"

  """
  def encrypt(number_list, seed \\ 0) do
    number =
      number_list
      |> List.to_tuple()
      |> then(fn tuple ->
        elem(tuple, 0) * 1000 +
          elem(tuple, 1) * 100 +
          elem(tuple, 2) * 10 +
          elem(tuple, 3)
      end)
      |> Kernel.+(seed)

    to_string([number])
  end

  @doc """
  ## Examples

      iex> BullsAndCows.decrypt("}", 2)
      [0,1,2,3]

  """
  def decrypt(character, seed \\ 0) do
    number_list =
      character
      |> to_charlist
      |> hd
      |> Kernel.-(seed)
      |> Integer.digits()

    if 3 == length(number_list) do
      [0 | number_list]
    else
      number_list
    end
  end
end
