defmodule Pentago.Web.GameLive do
  use Phoenix.LiveView
  alias Pentago.Game

  def render(assigns) do
    Pentago.Web.GameView.render("live.html", assigns)
  end

  def mount(%{game_id: game_id}, socket) do
    Process.send_after(self, {:join, game_id}, 100)

    {:ok, assign(socket, board: %Pentago.Board{}, selected: nil)}
  end

  def handle_event("select_marble", position, socket) do
    {:noreply, assign(socket, :selected, String.to_integer(position))}
  end

  def handle_event("make_move", rotation, socket) do
    move = build_move(socket.assigns.selected, rotation)
    board = Pentago.Board.move(socket.assigns.board, move)

    {:noreply, assign(socket, board: board, selected: nil)}
  end

  def handle_info({:join, game_id}, socket) do
    case Game.join(game_id) do
      {:ok, game} ->
        {:noreply, assign(socket, game: game)}
      {:error, reason} ->
        IO.inspect reason
        {:noreply, socket}
    end
  end

  defp build_move(position, rotation) do
    [sub_board, rotation] = String.split(rotation, "-")
    %Pentago.Move{
      marble: :black,
      position: position,
      sub_board: String.to_existing_atom(sub_board),
      rotation: String.to_existing_atom(rotation)
    }
  end
end
