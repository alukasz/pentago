defmodule Pentago.Web.GameChannel do
  use Phoenix.Channel
  alias Pentago.Game
  alias Pentago.Game.Board

  def join("game", _message, socket) do
    {:ok, socket}
  end

  def handle_in("start_game", %{"player1" => player1, "player2" => player2}, socket) do
    Game.start_link(player1, player2)

    board = Tuple.duplicate(2, 36)
    |> Tuple.to_list
    |> Enum.map(fn color ->
      case color do
        0 -> "black"
        1 -> "white"
        2 -> "empty"
      end
    end)

    push socket, "initial_board", %{board: board, color: "black", player: player1}

    {:noreply, socket}
  end

  def handle_in("make_move", move, socket) do
    payload = Game.make_move(format_move(move))

    push socket, "new_board", payload

    {:noreply, socket}
  end

  defp format_move(%{"player" => "human"} = move) do
    %{
      player: :human,
      pos: String.to_integer(move["pos"]),
      color: String.to_existing_atom(move["color"]),
      sub_board: move["sub_board"],
      rotation: rotation(move["rotation"])
    }
  end
  defp format_move(move) do
    %{
      player: String.to_existing_atom(move["player"]),
      color: String.to_existing_atom(move["color"])
    }
  end

  defp rotation("clockwise"), do: 0
  defp rotation("counter_clockwise"), do: 1
end
