defmodule BullsAndCows do
  use Accessible

  @moduledoc """
  A game of bulls and cows, rules:
  You need to guess 4 different numbers in definite order.
  If number is correct but in wrong position, its a cow, if value and position is correct, its a bull.

  Game should be played in iex. First you init game by new_game/0,
  then you should pass state to make_turn/2 until you win
  """

  @seed_range 500

  defstruct number_encrypted: "",
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
      number_encrypted: encrypt(number, seed),
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

  """
  def make_turn(%__MODULE__{win: false} = state, answer) do
    riddle_list = decrypt(state[:number_encrypted], state[:seed])
    answer_list = answer_to_list(answer)

    case check_turn(riddle_list, answer_list) do
      %{bulls: bulls, cows: cows} ->
        %{
          state
          | moves: [%{answer: answer, bulls: bulls, cows: cows} | state[:moves]],
            win: 4 == bulls
        }

      %{error: error} ->
        %{state | moves: [%{answer: answer, error: error} | state[:moves]]}
    end
  end

  def answer_to_list(answer) when answer > 100 and answer < 9999 do
    answer
    |> Integer.digits()
    |> add_heading_zero()
  end

  def answer_to_list(answer) when not is_integer(answer), do: %{error: :not_a_number}
  def answer_to_list(answer) when 0 > answer, do: %{error: :negative_number}
  def answer_to_list(_), do: %{error: :incorrect_length}

  @doc """
  Checks count of bulls and cows in answer

  ## Examples

      iex> BullsAndCows.check_turn([1,2,3,4], [0,2,3,1])
      %{bulls: 2, cows: 1}

  """
  def check_turn(_, %{error: error}), do: %{error: error}
  def check_turn(riddle, answer), do: check_turn(riddle, answer, 0, 0)

  def check_turn(_riddle, [], bulls, cows), do: %{bulls: bulls, cows: cows}

  def check_turn(riddle, [head | tail], bulls, cows) do
    cond do
      head in tail ->
        %{error: :duplicated_digits}

      head == Enum.at(riddle, 3 - length(tail)) ->
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
  def generate_number_list, do: generate_number_list([])
  def generate_number_list([_, _, _, _] = number_list), do: number_list

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
  def encrypt([t, h, d, u], seed \\ 0) do
    to_string([seed + t * 1_000 + h * 100 + d * 10 + u])
  end

  @doc """
  ## Examples

      iex> BullsAndCows.decrypt("}", 2)
      [0,1,2,3]

  """
  def decrypt(<<character::utf8>>, seed \\ 0) do
    character
    |> Kernel.-(seed)
    |> Integer.digits()
    |> add_heading_zero()
  end

  @doc """
  ## Examples

      iex> BullsAndCows.add_heading_zero([1,2,3])
      [0,1,2,3]

      iex> BullsAndCows.add_heading_zero([1,2,3,4])
      [1,2,3,4]

  """
  def add_heading_zero(number_list), do: List.duplicate(0, 4 - length(number_list)) ++ number_list
end
