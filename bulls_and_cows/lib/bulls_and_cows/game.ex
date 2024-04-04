defmodule BullsAndCows.Game do
  @moduledoc """
  A game of bulls and cows, rules:
  You need to guess 4 different numbers in definite order.
  If number is correct but in wrong position, its a cow, if value and position is correct, its a bull.

  Game should be played in iex. First you init game by new_game/0,
  then you should pass state to make_turn/2 until you win
  """

  defstruct number: [],
            moves: [],
            win: false

  @doc """
  Returns game state
  """
  def new_game() do
    number = generate_number_list()

    %__MODULE__{
      number: number,
      moves: [],
      win: false
    }
  end

  @doc """
  Updates state with your answer, checks win conditions
  """
  def make_turn(%__MODULE__{win: false} = state, answer) do
    riddle_list = state.number
    answer_list = answer_to_list(answer)

    case check_turn(riddle_list, answer_list) do
      %{bulls: bulls, cows: cows} ->
        %{
          state
          | moves: [%{answer: answer, bulls: bulls, cows: cows} | state.moves],
            win: 4 == bulls
        }

      %{error: error} ->
        %{state | moves: [%{answer: answer, error: error} | state.moves]}
    end
  end

  defp answer_to_list(answer) when answer > 100 and answer < 9999 do
    answer
    |> Integer.digits()
    |> add_heading_zero()
  end

  defp answer_to_list(answer) when not is_integer(answer), do: %{error: :not_a_number}
  defp answer_to_list(answer) when 0 > answer, do: %{error: :negative_number}
  defp answer_to_list(_), do: %{error: :incorrect_length}

  defp check_turn(_, %{error: error}), do: %{error: error}
  defp check_turn(riddle, answer), do: check_turn(riddle, answer, 0, 0)

  defp check_turn(_riddle, [], bulls, cows), do: %{bulls: bulls, cows: cows}

  defp check_turn(riddle, [head | tail], bulls, cows) do
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

  defp generate_number_list, do: generate_number_list([])
  defp generate_number_list([_, _, _, _] = number_list), do: number_list

  defp generate_number_list(number_list) do
    digit = Enum.random(0..9)

    # I do not want to overcomplicate
    if Enum.member?(number_list, digit) do
      generate_number_list(number_list)
    else
      generate_number_list([digit | number_list])
    end
  end

  def add_heading_zero(number_list), do: List.duplicate(0, 4 - length(number_list)) ++ number_list
end
