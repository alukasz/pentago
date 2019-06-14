defmodule Pentago.Board do
  alias Pentago.Board
  alias Pentago.Move

  @marbles Tuple.duplicate(:empty, 36) |> Tuple.to_list()

  defstruct marbles: @marbles, winner: :empty, moves_history: []

  def move(%Board{} = board, %Move{} = move) do
    {new_nif_board, _, _, _, _, winner, _, _} =
      Pentago.Game.BitBoard.move(
        to_nif_board(board),
        move.position,
        color(move.marble),
        sub_board(move.sub_board),
        rotation(move.rotation)
      )

    %Board{board | marbles: from_nif_board(new_nif_board), winner: color(winner),
           moves_history: [move | board.moves_history]}
  end

  defp to_nif_board(%{marbles: marbles}) do
    marbles
    |> Enum.map(&color/1)
    |> List.to_tuple()
  end

  defp from_nif_board(board) do
    board
    |> Tuple.to_list()
    |> Enum.map(&color/1)
  end

  def color(:black), do: 0
  def color(:white), do: 1
  def color(:empty), do: 2
  def color(0), do: :black
  def color(1), do: :white
  def color(2), do: :empty

  def sub_board(:top_left), do: 0
  def sub_board(:top_right), do: 1
  def sub_board(:bottom_left), do: 2
  def sub_board(:bottom_right), do: 3
  def sub_board(0), do: :top_left
  def sub_board(1), do: :top_right
  def sub_board(2), do: :bottom_left
  def sub_board(3), do: :bottom_right

  def rotation(:clockwise), do: 0
  def rotation(:counter_clockwise), do: 1
  def rotation(0), do: :clockwise
  def rotation(1), do: :counter_clockwise
end
