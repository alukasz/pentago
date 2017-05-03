defmodule Pentago.Web.GameChannel do
  use Phoenix.Channel
  alias Pentago.Game
  alias Pentago.Game.Board

  def join("game", _message, socket) do
    Game.start_link

    # push socket, "new_board", %{board: board}

    {:ok, socket}
  end

  def handle_in("make_move", move, socket) do
    board = Game.make_move(format_move(move))
    |> Tuple.to_list

    push socket, "new_board", %{board: board}

    {:noreply, socket}
  end

  defp format_move(move) do
    {
      move["pos"],
      move["color"],
      move["sub_board"],
      move["rotation"]
    }
  end
end
