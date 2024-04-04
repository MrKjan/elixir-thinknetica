defmodule BullsAndCowsWeb.PageControllerTest do
  use BullsAndCowsWeb.ConnCase
  import Phoenix.LiveViewTest

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Peace of mind from prototype to production"
  end

  test "GET /game", %{conn: conn} do
    conn = get(conn, ~p"/game")
    assert html_response(conn, 200) =~ "Bulls and Cows"
  end

  test "Check win label", %{conn: conn} do
    conn = get(conn, ~p"/game")
    {:ok, view, _html} = live(conn)

    # becomes obsolete after live/1 call, because mount/3 get invoked again >_<
    input = conn.assigns.game_state.number
      |> Enum.map(&Integer.to_string/1)
      |> List.to_string

    assert view
      |> element("form")
      |> render_submit(%{"answer" => input}) =~ "\n  bulls: "
    # But I want to see "You won!" really :'(
  end
end
