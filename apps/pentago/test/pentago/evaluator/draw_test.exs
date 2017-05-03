defmodule Pentago.Evaluator.DrawTest do
  use ExUnit.Case, async: true
  alias Pentago.Evaluator.Draw

  describe "Draw.evaluate/1" do
    setup do
      board = {
        :black, :white, :black, :black, :white, :black,
        :white, :black, :black, :white, :black, :black,
        :black, :black, :white, :black, :black, :white,
        :black, :white, :black, :black, :white, :black,
        :white, :black, :black, :white, :black, :black,
        :black, :black, :white, :black, :black, :white
      }

      {:ok, board: board}
    end

    test "returns true if there is no empty color on board", %{board: board} do
      assert Draw.evaluate(board)
    end

    test "returns false if there is empty color on board", %{board: board} do
      board = put_elem(board, 20, :empty)

      refute Draw.evaluate(board)
    end
  end
end
