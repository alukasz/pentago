defmodule Pentago.Web.GameChannel do
  use Phoenix.Channel
  require Logger
  alias Pentago.Game

  def join("game", _message, socket) do
    Process.flag(:trap_exit, true)

    {:ok, socket}
  end

  def handle_in("start_game", state, socket) do
    board = Tuple.duplicate(2, 36)
    |> Tuple.to_list

    game_state = %{
      depth1: String.to_integer(state["depth1"]),
      depth2: String.to_integer(state["depth2"]),
      player1: String.to_integer(state["player1"]),
      player2: String.to_integer(state["player2"]),
      eval1: String.to_integer(state["eval1"]),
      eval2: String.to_integer(state["eval2"]),
      mg1: String.to_integer(state["mg1"]),
      mg2: String.to_integer(state["mg2"]),
      board: board,
      turn: 0,
      moves: []
    }
    Game.start_link(game_state)

    push socket, "initial_board", %{board: board, color: "black", player: game_state.player1}

    {:noreply, socket}
  end

  def handle_in("make_move", move, socket) do
    payload = Game.make_move(format_move(move))

    push socket, "new_board", payload

    {:noreply, socket}
  end

  def terminate(reason, _socket) do
    Logger.debug"leave: #{inspect reason}"
    Game.close()

    :ok
  end

  defp format_move(move) do
    %{
      pos: move["pos"],
      color: move["color"],
      sub_board: move["sub_board"],
      rotation: move["rotation"]
    }
  end
end

