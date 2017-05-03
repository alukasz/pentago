defmodule Pentago.Game do
  use GenServer
  alias Pentago.Game.Board
  alias Pentago.Algorithm.Random

  @name __MODULE__

  def start_link do
    GenServer.start_link(@name, [], name: @name)
  end

  def init(_) do
    board = Board.new()

    {:ok, board}
  end

  def make_move(move) do
    GenServer.call(@name, {:make_move, move})
  end

  def handle_call({:make_move, move}, _from, board) do
    color = elem(move, 1)
    move = Random.get_move(board, color, 0, 0)
    new_board = Board.move(board, move)

    {:reply, new_board, new_board}
  end
end
