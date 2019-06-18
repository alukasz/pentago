defmodule Pentago.Game.BitBoardTest do
  use ExUnit.Case, async: true
  alias Pentago.Game.BitBoard

  @black 0
  @white 1
  @empty 2
  @clockwise 0
  @counter_clockwise 1

  describe "BitBoard.move/5" do
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

    test "updates board black 0", %{board: board} do
      board = put_elem(board, 0, @empty)
      move = {0, @black, 3, @clockwise}

      new_board = make_move(board, move)

      assert elem(new_board, 0) == @black
    end

    test "updates board white 0", %{board: board} do
      board = put_elem(board, 0, @empty)
      move = {0, @white, 3, @clockwise}

      new_board = make_move(board, move)

      assert elem(new_board, 0) == @white
    end


    test "updates board white 20", %{board: board} do
      move = {20, @white, 0, @clockwise}

      new_board = make_move(board, move)

      assert elem(new_board, 20) == @white
    end

    test "updates board black 20", %{board: board} do
      move = {20, @black, 0, @clockwise}

      new_board = make_move(board, move)

      assert elem(new_board, 20) == @black
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

  defp make_move(board, {pos, color, sub_board, rotation}) do
    result = BitBoard.move(board, pos, color, sub_board, rotation)

    elem(result, 0)
  end
end
