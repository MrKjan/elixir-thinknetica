defmodule BullsAndCowsTest do
  use ExUnit.Case
  doctest BullsAndCows

  test "small answer" do
    game = %BullsAndCows{number_encrypted: "{", seed: 0, moves: [], win: false}
    game = BullsAndCows.make_turn(game, 19)
    assert %BullsAndCows{moves: [%{error: :incorrect_length} | _]} = game
  end

  test "big answer" do
    game = %BullsAndCows{number_encrypted: "{", seed: 0, moves: [], win: false}
    game = BullsAndCows.make_turn(game, 1_234_467)
    assert %BullsAndCows{moves: [%{error: :incorrect_length} | _]} = game
  end

  test "not a number answer" do
    game = %BullsAndCows{number_encrypted: "{", seed: 0, moves: [], win: false}
    game = BullsAndCows.make_turn(game, "asdf")
    assert %BullsAndCows{moves: [%{error: :not_a_number} | _]} = game
  end

  test "negative answer" do
    game = %BullsAndCows{number_encrypted: "{", seed: 0, moves: [], win: false}
    game = BullsAndCows.make_turn(game, -123)
    assert %BullsAndCows{moves: [%{error: :negative_number} | _]} = game
  end

  test "duplicated digits answer" do
    game = %BullsAndCows{number_encrypted: "{", seed: 0, moves: [], win: false}
    game = BullsAndCows.make_turn(game, 1111)
    assert %BullsAndCows{moves: [%{error: :duplicated_digits} | _]} = game
  end
end
