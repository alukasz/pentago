defmodule Pentago.Game.FastBoardTest do
  use ExUnit.Case, async: true
  alias Pentago.Game.FastBoard

  @black 0
  @white 1
  @empty 2
  @clockwise 0
  @counter_clockwise 1

  @in_vector0 0
  @in_vector1 1
  @in_vector2 10
  @in_vector3 100
  @in_vector4 1000
  @in_vector5 1000
  @in_vector6 100000

  @in_row0 0
  @in_row1 0
  @in_row2 10
  @in_row3 100
  @in_row4 1000
  @in_row5 100000
  @in_row6 100000

  describe "FastBoard.move/5" do
    setup do
      board = {
        @black, @white, @empty, @black, @white, @empty,
        @white, @empty, @black, @white, @empty, @black,
        @empty, @black, @white, @empty, @black, @white,

        @black, @white, @empty, @black, @white, @empty,
        @white, @empty, @black, @white, @empty, @black,
        @empty, @black, @white, @empty, @black, @white
      }

      {:ok, board: board}
    end

    test "updates board", %{board: board} do
      move = {0, @white, 3, @clockwise}

      new_board = make_move(board, move)

      assert elem(new_board, 0) == @white
    end

    test "rotates first sub board @clockwise", %{board: board} do
      move = {0, @black, 0, @clockwise}

      new_board = make_move(board, move)

      assert elem(new_board, 0) == @empty
      assert elem(new_board, 1) == @white
      assert elem(new_board, 2) == @black
    end

    test "rotates first sub board counter @clockwise", %{board: board} do
      move = {0, @black, 0, @counter_clockwise}

      new_board = make_move(board, move)

      assert elem(new_board, 0) == @empty
      assert elem(new_board, 1) == @black
      assert elem(new_board, 2) == @white
    end

    test "rotates second sub board @clockwise", %{board: board} do
      move = {0, @black, 1, @clockwise}

      new_board = make_move(board, move)

      assert elem(new_board, 3) == @empty
      assert elem(new_board, 4) == @white
      assert elem(new_board, 5) == @black
      assert elem(new_board, 9) == @black
      assert elem(new_board, 10) == @empty
      assert elem(new_board, 11) == @white
      assert elem(new_board, 15) == @white
      assert elem(new_board, 16) == @black
      assert elem(new_board, 17) == @empty
    end

    test "rotates second sub board counter @clockwise", %{board: board} do
      move = {0, @black, 1, @counter_clockwise}

      new_board = make_move(board, move)

      assert elem(new_board, 3) == @empty
      assert elem(new_board, 4) == @black
      assert elem(new_board, 5) == @white
      assert elem(new_board, 9) == @white
      assert elem(new_board, 10) == @empty
      assert elem(new_board, 11) == @black
      assert elem(new_board, 15) == @black
      assert elem(new_board, 16) == @white
      assert elem(new_board, 17) == @empty
    end

    test "rotates third sub board @clockwise", %{board: board} do
      move = {0, @black, 2, @clockwise}

      new_board = make_move(board, move)

      assert elem(new_board, 24) == @black
      assert elem(new_board, 25) == @empty
      assert elem(new_board, 26) == @white
    end

    test "rotates third sub board counter @clockwise", %{board: board} do
      move = {0, @black, 2, @counter_clockwise}

      new_board = make_move(board, move)

      assert elem(new_board, 24) == @white
      assert elem(new_board, 25) == @empty
      assert elem(new_board, 26) == @black
    end

    test "rotates fourth sub board @clockwise", %{board: board} do
      move = {0, @black, 3, @clockwise}

      new_board = make_move(board, move)

      assert elem(new_board, 21) == @empty
      assert elem(new_board, 22) == @white
      assert elem(new_board, 23) == @black
      assert elem(new_board, 27) == @black
      assert elem(new_board, 28) == @empty
      assert elem(new_board, 29) == @white
      assert elem(new_board, 33) == @white
      assert elem(new_board, 34) == @black
      assert elem(new_board, 35) == @empty
    end

    test "rotates fourth sub board counter @clockwise", %{board: board} do
      move = {0, @black, 3, @counter_clockwise}

      new_board = make_move(board, move)

      assert elem(new_board, 21) == @empty
      assert elem(new_board, 22) == @black
      assert elem(new_board, 23) == @white
      assert elem(new_board, 27) == @white
      assert elem(new_board, 28) == @empty
      assert elem(new_board, 29) == @black
      assert elem(new_board, 33) == @black
      assert elem(new_board, 34) == @white
      assert elem(new_board, 35) == @empty
    end
  end

	describe "FastBoard.points_@in_vectors/1" do
    setup do
      board = Tuple.duplicate(@empty, 36)

      {:ok, board: board}
    end

    test "empty board", %{board: board} do
      assert FastBoard.points_in_vectors(board) == 0
    end

    test "6 black", %{board: board} do
      board = board
      |> put_elem(0, @black)
      |> put_elem(1, @black)
      |> put_elem(2, @black)
      |> put_elem(3, @black)
      |> put_elem(4, @black)
      |> put_elem(5, @black)

      assert FastBoard.points_in_vectors(board) > @in_vector6
    end

    test "6 white", %{board: board} do
      board = board
      |> put_elem(0, @white)
      |> put_elem(1, @white)
      |> put_elem(2, @white)
      |> put_elem(3, @white)
      |> put_elem(4, @white)
      |> put_elem(5, @white)
      assert FastBoard.points_in_vectors(board) < -@in_vector6
    end

    test "5 black", %{board: board} do
      board = board
      |> put_elem(0, @black)
      |> put_elem(1, @black)
      |> put_elem(2, @black)
      |> put_elem(3, @black)
      |> put_elem(4, @empty)
      |> put_elem(5, @black)

      res = FastBoard.points_in_vectors(board)

      assert res > @in_vector5
      assert res < @in_vector6
    end

    test "5 black 1 white", %{board: board} do
      board = board
      |> put_elem(0, @black)
      |> put_elem(1, @black)
      |> put_elem(2, @black)
      |> put_elem(3, @black)
      |> put_elem(4, @white)
      |> put_elem(5, @black)

      res = FastBoard.points_in_vectors(board)

      assert res > @in_vector4
      assert res < @in_vector6
    end

    test "4 black", %{board: board} do
      board = board
      |> put_elem(0, @black)
      |> put_elem(1, @black)
      |> put_elem(2, @empty)
      |> put_elem(3, @black)
      |> put_elem(4, @empty)
      |> put_elem(5, @black)

      res = FastBoard.points_in_vectors(board)

      assert res > @in_vector4
      assert res < @in_vector6
    end

    test "4 black 1 white", %{board: board} do
      board = board
      |> put_elem(0, @black)
      |> put_elem(1, @black)
      |> put_elem(2, @empty)
      |> put_elem(3, @black)
      |> put_elem(4, @white)
      |> put_elem(5, @black)

      res = FastBoard.points_in_vectors(board)

      assert res > @in_vector3
      assert res < @in_vector4
    end

    test "4 black 2 white", %{board: board} do
      board = board
      |> put_elem(0, @black)
      |> put_elem(1, @white)
      |> put_elem(2, @black)
      |> put_elem(3, @black)
      |> put_elem(4, @white)
      |> put_elem(5, @black)

      res = FastBoard.points_in_vectors(board)

      assert res > @in_vector0
      assert res < @in_vector2
    end

    test "3 black 3 white", %{board: board} do
      board = board
      |> put_elem(0, @black)
      |> put_elem(1, @white)
      |> put_elem(2, @white)
      |> put_elem(3, @black)
      |> put_elem(4, @white)
      |> put_elem(5, @black)

      res = FastBoard.points_in_vectors(board)

      assert res == @in_vector0
    end

    test "3 black 2 white", %{board: board} do
      board = board
      |> put_elem(0, @white)
      |> put_elem(1, @black)
      |> put_elem(2, @empty)
      |> put_elem(3, @black)
      |> put_elem(4, @white)
      |> put_elem(5, @black)

      res = FastBoard.points_in_vectors(board)

      assert res > @in_vector0
      assert res < @in_vector2
    end

    test "2 black 2 white", %{board: board} do
      board = board
      |> put_elem(0, @black)
      |> put_elem(1, @white)
      |> put_elem(2, @empty)
      |> put_elem(3, @empty)
      |> put_elem(4, @white)
      |> put_elem(5, @black)

      res = FastBoard.points_in_vectors(board)

      assert res >= @in_vector0
      assert res < @in_vector2
    end

    test "1 black", %{board: board} do
      board = board
      |> put_elem(2, @black)

      res = FastBoard.points_in_vectors(board)

      assert res > @in_vector1
      assert res < @in_vector2
    end
  end

  describe "FastBoard.points_in_rows/1" do
    setup do
      board = Tuple.duplicate(@empty, 36)

      {:ok, board: board}
    end

    test "empty board", %{board: board} do
      assert FastBoard.points_in_rows(board) == 0
    end


    test "6 black", %{board: board} do
      board = board
      |> put_elem(0, @black)
      |> put_elem(1, @black)
      |> put_elem(2, @black)
      |> put_elem(3, @black)
      |> put_elem(4, @black)
      |> put_elem(5, @black)

      assert FastBoard.points_in_rows(board) == @in_row6
    end

    test "6 white", %{board: board} do
      board = board
      |> put_elem(0, @white)
      |> put_elem(1, @white)
      |> put_elem(2, @white)
      |> put_elem(3, @white)
      |> put_elem(4, @white)
      |> put_elem(5, @white)
      assert FastBoard.points_in_rows(board) == -@in_row6
    end

    test "5 black in the beginning of a vector", %{board: board} do
      board = board
      |> put_elem(0, @black)
      |> put_elem(1, @black)
      |> put_elem(2, @black)
      |> put_elem(3, @black)
      |> put_elem(4, @black)

      res = FastBoard.points_in_rows(board)

      assert res == @in_row5
    end

    test "4 black in the end of a vector", %{board: board} do
      board = board
      |> put_elem(0, @white)
      |> put_elem(1, @black)
      |> put_elem(2, @black)
      |> put_elem(3, @black)
      |> put_elem(4, @black)
      |> put_elem(5, @black)

      res = FastBoard.points_in_rows(board)

      assert res == @in_row5
    end

    test "3 black 3 white", %{board: board} do
      board = board
      |> put_elem(0, @black)
      |> put_elem(1, @black)
      |> put_elem(2, @black)
      |> put_elem(3, @white)
      |> put_elem(4, @white)
      |> put_elem(5, @white)

      res = FastBoard.points_in_rows(board)

      assert res == 0
    end

    test "2 black 2 white 2 black", %{board: board} do
      board = board
      |> put_elem(0, @black)
      |> put_elem(1, @black)
      |> put_elem(2, @white)
      |> put_elem(3, @white)
      |> put_elem(4, @black)
      |> put_elem(5, @black)

      res = FastBoard.points_in_rows(board)

      assert res == @in_row2
    end

    test "nothing in the row", %{board: board} do
      board = board
      |> put_elem(0, @black)
      |> put_elem(1, @white)
      |> put_elem(2, @black)
      |> put_elem(3, @white)
      |> put_elem(4, @black)
      |> put_elem(5, @white)

      res = FastBoard.points_in_rows(board)

      assert res == 0
    end
  end

  defp make_move(board, {pos, color, sub_board, rotation}) do
    result = FastBoard.move(board, pos, color, sub_board, rotation)

    elem(result, 0)
  end
end
