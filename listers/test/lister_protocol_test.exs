defmodule ListerProtocolTest do
  use ExUnit.Case
  doctest ListerProtocol

  test "Check list" do
    assert ListerProtocol.to_list([1, 2, 3, 4, 5]) == [1, 2, 3, 4, 5]
  end

  test "Check map" do
    assert ListerProtocol.to_list(%{a: 1, b: 2, c: 3}) == [c: 3, a: 1, b: 2]
  end

  test "Check tuple" do
    assert ListerProtocol.to_list({1, 2, 3, 4, 5}) == [1, 2, 3, 4, 5]
  end

  test "Check range" do
    assert ListerProtocol.to_list(1..10) == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  end

  test "Check function" do
    assert ListerProtocol.to_list(&Kernel.+/1) == [
             module: :erlang,
             name: :+,
             arity: 1,
             env: [],
             type: :external
           ]
  end

  test "Check string" do
    assert ListerProtocol.to_list("abcde") == [97, 98, 99, 100, 101]
  end

  test "Check integer" do
    assert ListerProtocol.to_list(12345) == [1, 2, 3, 4, 5]
  end
end
