defmodule ListerBehaviourTest do
  alias SenselessStruct
  use ExUnit.Case
  doctest ListerBehaviour

  test "checks to_list/1 for SenselessStruct" do
    data = %SenselessStruct{data: [1, 2, 3], state: "idle", err_code: :overflow}
    assert SenselessStruct.to_list(data) == [[1, 2, 3], "idle", :overflow]
  end
end
