defmodule Pentago.Web.GameChannel do
  use Phoenix.Channel
  require Logger
  alias Pentago.Game
  alias Pentago.Game.Board

  def join("game", _message, socket) do
    Process.flag(:trap_exit, true)

    {:ok, socket}
  end

  def handle_in("start_game", %{"player1" => player1, "player2" => player2, "depth" => depth}, socket) do
    Game.start_link(player1, player2, String.to_integer(depth))

    board = Tuple.duplicate(2, 36)
    |> Tuple.to_list

    push socket, "initial_board", %{board: board, color: "black", player: player1}

    {:noreply, socket}
  end

  def handle_in("make_move", move, socket) do
    payload = Game.make_move(format_move(move))

    push socket, "new_board", payload

    {:noreply, socket}
  end

  def terminate(reason, _socket) do
    Logger.debug"> leave #{inspect reason}"
    Game.close()
    :ok
  end

  defp format_move(%{"player" => "human"} = move) do
    %{
      player: :human,
      pos: String.to_integer(move["pos"]),
      color: move["color"],
      sub_board: move["sub_board"],
      rotation: move["rotation"]
    }
  end
  defp format_move(move) do
    %{
      player: String.to_existing_atom(move["player"]),
      color: move["color"]
    }
  end
end
