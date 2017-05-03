defmodule Pentago.Algorithm.Random do
  alias Pentago.Game.Board

  def get_move(board, color, _, _) do
    Enum.random(Board.available_moves(board, color))
  end
end
