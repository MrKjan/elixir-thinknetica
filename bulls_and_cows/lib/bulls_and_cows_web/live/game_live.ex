  defmodule BullsAndCowsWeb.GameLive do
  alias BullsAndCows.Game
  use BullsAndCowsWeb, :live_view

  def mount(_params, _session, socket) do
    {
      :ok,
      assign(
        socket,
        game_state: Game.new_game(),
        form: %{}
      )}
  end

  def render(assigns) do
    ~H"""
    <h1> Bulls and Cows </h1>
    <%= for %{answer: answer, bulls: bulls, cows: cows} <- @game_state.moves do %>
      <%= answer %>
      bulls: <%= bulls %>
      cows: <%= cows %>
      <br>
    <% end %>
    <%= if not @game_state.win do %>
      <.form for={@form} phx-submit="submit_value">
          <%= if not Enum.empty?(@game_state.moves) and :error in Map.keys(hd(@game_state.moves)) do %>
            <%= with %{error: error, answer: _} <- hd(@game_state.moves) do %>
              <%= error %><br>
            <% end %>
          <% end %>
          <input type="text" name="answer" inputmode="numeric" maxlength="4" autocomplete="off"><br><br>
          <.button type="submit">Submit</.button>
      </.form>
    <% else %>
        You won!
    <% end %>
    """
  end

  def handle_event("submit_value", %{"answer" => answer}, socket) do
    answer = try do
      String.to_integer(answer)
    rescue
      ArgumentError -> answer
    end
    new_game_state = Game.make_turn(socket.assigns.game_state, answer)
    {:noreply, assign(socket, game_state: new_game_state)}
  end
end
