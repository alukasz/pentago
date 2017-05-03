defmodule Pentago.Evaluator.InVectorTest do
  use ExUnit.Case, async: true
  alias Pentago.Evaluator.InVector

	describe "InVector.evaluate/1" do
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

    test "empty board", %{board: board} do
      assert InVector.evaluate(board) == 0
    end

    test "6 black", %{board: board} do
      board = board
      |> put_elem(0, :black)
      |> put_elem(1, :black)
      |> put_elem(2, :black)
      |> put_elem(3, :black)
      |> put_elem(4, :black)
      |> put_elem(5, :black)

      assert InVector.evaluate(board) > in_vector6()
    end

    test "6 white", %{board: board} do
      board = board
      |> put_elem(0, :white)
      |> put_elem(1, :white)
      |> put_elem(2, :white)
      |> put_elem(3, :white)
      |> put_elem(4, :white)
      |> put_elem(5, :white)
      assert InVector.evaluate(board) < -in_vector6()
    end

    test "5 black", %{board: board} do
      board = board
      |> put_elem(0, :black)
      |> put_elem(1, :black)
      |> put_elem(2, :black)
      |> put_elem(3, :black)
      |> put_elem(4, :empty)
      |> put_elem(5, :black)

      res = InVector.evaluate(board)

      assert res > in_vector5()
      assert res < in_vector6()
    end

    test "5 black 1 white", %{board: board} do
      board = board
      |> put_elem(0, :black)
      |> put_elem(1, :black)
      |> put_elem(2, :black)
      |> put_elem(3, :black)
      |> put_elem(4, :white)
      |> put_elem(5, :black)

      res = InVector.evaluate(board)

      assert res > in_vector4()
      assert res < in_vector5()
    end

    test "4 black", %{board: board} do
    board = board
    |> put_elem(0, :black)
      |> put_elem(1, :black)
      |> put_elem(2, :empty)
      |> put_elem(3, :black)
      |> put_elem(4, :empty)
      |> put_elem(5, :black)

      res = InVector.evaluate(board)

      assert res > in_vector4()
      assert res < in_vector5()
    end

    test "4 black 1 white", %{board: board} do
      board = board
      |> put_elem(0, :black)
      |> put_elem(1, :black)
      |> put_elem(2, :empty)
      |> put_elem(3, :black)
      |> put_elem(4, :white)
      |> put_elem(5, :black)

      res = InVector.evaluate(board)

      assert res > in_vector3()
      assert res < in_vector4()
    end

    test "4 black 2 white", %{board: board} do
      board = board
      |> put_elem(0, :black)
      |> put_elem(1, :white)
      |> put_elem(2, :black)
      |> put_elem(3, :black)
      |> put_elem(4, :white)
      |> put_elem(5, :black)

      res = InVector.evaluate(board)

      assert res > in_vector0()
      assert res < in_vector2()
    end

    test "3 black 3 white", %{board: board} do
      board = board
      |> put_elem(0, :black)
      |> put_elem(1, :white)
      |> put_elem(2, :white)
      |> put_elem(3, :black)
      |> put_elem(4, :white)
      |> put_elem(5, :black)

      res = InVector.evaluate(board)

      assert res == in_vector0()
    end

    test "3 black 2 white", %{board: board} do
      board = board
      |> put_elem(0, :white)
      |> put_elem(1, :black)
      |> put_elem(2, :empty)
      |> put_elem(3, :black)
      |> put_elem(4, :white)
      |> put_elem(5, :black)

      res = InVector.evaluate(board)

      assert res > in_vector0()
      assert res < in_vector2()
    end

    test "2 black 2 white", %{board: board} do
      board = board
      |> put_elem(0, :black)
      |> put_elem(1, :white)
      |> put_elem(2, :empty)
      |> put_elem(3, :empty)
      |> put_elem(4, :white)
      |> put_elem(5, :black)

      res = InVector.evaluate(board)

      assert res >= in_vector0()
      assert res < in_vector2()
    end

    test "1 black", %{board: board} do
      board = board
      |> put_elem(2, :black)

      res = InVector.evaluate(board)

      assert res > in_vector1()
      assert res < in_vector2()
    end
	end

  defp in_vector0, do: 0
  defp in_vector1, do: 1
  defp in_vector2, do: 10
  defp in_vector3, do: 100
  defp in_vector4, do: 1000
  defp in_vector5, do: 5000
  defp in_vector6, do: 100000
end
