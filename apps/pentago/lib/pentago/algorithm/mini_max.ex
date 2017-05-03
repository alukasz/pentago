defmodule Pentago.Algorithm.MiniMax do
  alias Pentago.Evaluator.InVector
  alias Pentago.Game.Board

  @min -9_999_999
  @max 9_999_999

  def get_move(board, color, _, depth),
    do: get_move_maximize(board, Board.available_moves(board, color), depth, color, @min, nil)

  defp get_move_maximize(_, [], _, _, _, best_move), do: best_move
  defp get_move_maximize(board, [move | moves], depth, color, max, best_move) do
    points = maximize(Board.move(board, move), depth - 1, opposite_color(color))
    case points > max do
      true -> get_move_maximize(board, moves, depth, color, points, move)
      _ -> get_move_maximize(board, moves, depth, color, max, best_move)
    end
  end

  defp maximize(board, 0, _), do: InVector.evaluate(board)
  defp maximize(board, depth, color) do
    maximize_loop(board, Board.available_moves(board, color), depth, color, @min)
  end

  defp maximize_loop(_, [], _, _, max), do: max
  defp maximize_loop(board, [move | moves], depth, color, max) do
    points = minimize(Board.move(board, move), depth - 1, opposite_color(color))
    case points > max do
      true -> maximize_loop(board, moves, depth, color, points)
      _ -> maximize_loop(board, moves, depth, color, max)
    end
  end

  defp minimize(board, 0, _), do: InVector.evaluate(board)
  defp minimize(board, depth, color) do
    minimize_loop(board, Board.available_moves(board, color), depth, color, @max)
  end

  defp minimize_loop(_, [], _, _, min), do: min
  defp minimize_loop(board, [move | moves], depth, color, min) do
    points = maximize(Board.move(board, move), depth - 1, opposite_color(color))
    case points < min do
      true -> minimize_loop(board, moves, depth, color, points)
      _ -> minimize_loop(board, moves, depth, color, min)
    end
  end

  defp opposite_color(:white), do: :black
  defp opposite_color(:black), do: :white
end
