defmodule Pentago.Game.BoardTest do
  use ExUnit.Case, async: true
  alias Pentago.Game.Board

  describe "Board.new/0" do
    test "creates a tuple of size 36" do
      board = Board.new()

      assert tuple_size(board) == 36
    end

    test "creates a tuple filled with :empty" do
      board = Board.new()
      |> Tuple.to_list

      assert Enum.all?(board, &(&1 == :empty))
    end
  end

  describe "Board.move/2" do
    setup do
      board = {
        :black, :white, :empty, :black, :white, :empty,
        :white, :empty, :black, :white, :empty, :black,
        :empty, :black, :white, :empty, :black, :white,
        :black, :white, :empty, :black, :white, :empty,
        :white, :empty, :black, :white, :empty, :black,
        :empty, :black, :white, :empty, :black, :white
      }

      {:ok, board: board}
    end

    test "updates board", %{board: board} do
      move = {0, :white, 3, :clockwise}

      new_board = Board.move(board, move)

      assert elem(new_board, 0) == :white
    end

    test "rotates first sub board clockwise", %{board: board} do
      move = {0, :black, 0, :clockwise}

      new_board = Board.move(board, move)

      assert elem(new_board, 0) == :empty
      assert elem(new_board, 1) == :white
      assert elem(new_board, 2) == :black
    end

    test "rotates first sub board counter clockwise", %{board: board} do
      move = {0, :black, 0, :counter_clockwise}

      new_board = Board.move(board, move)

      assert elem(new_board, 0) == :empty
      assert elem(new_board, 1) == :black
      assert elem(new_board, 2) == :white
    end

    test "rotates second sub board clockwise", %{board: board} do
      move = {0, :black, 1, :clockwise}

      new_board = Board.move(board, move)

      assert elem(new_board, 3) == :empty
      assert elem(new_board, 4) == :white
      assert elem(new_board, 5) == :black
      assert elem(new_board, 9) == :black
      assert elem(new_board, 10) == :empty
      assert elem(new_board, 11) == :white
      assert elem(new_board, 15) == :white
      assert elem(new_board, 16) == :black
      assert elem(new_board, 17) == :empty
    end

    test "rotates second sub board counter clockwise", %{board: board} do
      move = {0, :black, 1, :counter_clockwise}

      new_board = Board.move(board, move)

      assert elem(new_board, 3) == :empty
      assert elem(new_board, 4) == :black
      assert elem(new_board, 5) == :white
      assert elem(new_board, 9) == :white
      assert elem(new_board, 10) == :empty
      assert elem(new_board, 11) == :black
      assert elem(new_board, 15) == :black
      assert elem(new_board, 16) == :white
      assert elem(new_board, 17) == :empty
    end

    test "rotates third sub board clockwise", %{board: board} do
      move = {0, :black, 2, :clockwise}

      new_board = Board.move(board, move)

      assert elem(new_board, 24) == :black
      assert elem(new_board, 25) == :empty
      assert elem(new_board, 26) == :white
    end

    test "rotates third sub board counter clockwise", %{board: board} do
      move = {0, :black, 2, :counter_clockwise}

      new_board = Board.move(board, move)

      assert elem(new_board, 24) == :white
      assert elem(new_board, 25) == :empty
      assert elem(new_board, 26) == :black
    end

    test "rotates fourth sub board clockwise", %{board: board} do
      move = {0, :black, 3, :clockwise}

      new_board = Board.move(board, move)

      assert elem(new_board, 33) == :white
      assert elem(new_board, 34) == :black
      assert elem(new_board, 35) == :empty
    end

    test "rotates fourth sub board counter clockwise", %{board: board} do
      move = {0, :black, 3, :counter_clockwise}

      new_board = Board.move(board, move)

      assert elem(new_board, 33) == :black
      assert elem(new_board, 34) == :white
      assert elem(new_board, 35) == :empty
    end
  end
end