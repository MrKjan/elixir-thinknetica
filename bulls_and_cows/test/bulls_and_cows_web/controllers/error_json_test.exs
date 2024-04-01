defmodule BullsAndCowsWeb.ErrorJSONTest do
  use BullsAndCowsWeb.ConnCase, async: true

  test "renders 404" do
    assert BullsAndCowsWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert BullsAndCowsWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
