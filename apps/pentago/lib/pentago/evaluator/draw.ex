defmodule Pentago.Evaluator.Draw do
  def evaluate(board) do
    board
    |> Tuple.to_list
    |> Enum.any?(&(&1 == :empty))
    |> Kernel.!
  end
end
