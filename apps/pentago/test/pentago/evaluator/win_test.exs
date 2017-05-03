defmodule Pentago.Evaluator.WinTest do
  use ExUnit.Case, async: true
  alias Pentago.Evaluator.Win

  describe "Win.evaluate/1" do
    setup do
      board = {
        :empty, :empty, :empty, :empty, :empty, :empty,
        :empty, :empty, :empty, :empty, :empty, :empty,
        :empty, :empty, :empty, :empty, :empty, :empty,
        :empty, :empty, :empty, :empty, :empty, :empty,
        :empty, :empty, :empty, :empty, :empty, :empty,
        :empty, :empty, :empty, :empty, :empty, :empty
      }

      {:ok, board: board}
    end

    test "returns :empty if there is no winner", %{board: board} do
      assert Win.evaluate(board) == :empty
    end

    test "finds winner in row", %{board: board} do
      board = board
      |> put_elem(0, :black)
      |> put_elem(1, :black)
      |> put_elem(2, :black)
      |> put_elem(3, :black)
      |> put_elem(4, :black)

      assert Win.evaluate(board) == :black
    end

    test "finds winner in column", %{board: board} do
      board = board
      |> put_elem(6, :black)
      |> put_elem(12, :black)
      |> put_elem(18, :black)
      |> put_elem(24, :black)
      |> put_elem(30, :black)

      assert Win.evaluate(board) == :black
    end

    test "finds winner in diagonal", %{board: board} do
      board = board
      |> put_elem(11, :black)
      |> put_elem(16, :black)
      |> put_elem(21, :black)
      |> put_elem(26, :black)
      |> put_elem(31, :black)

      assert Win.evaluate(board) == :black
    end
  end
end
