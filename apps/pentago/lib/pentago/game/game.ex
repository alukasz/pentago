defmodule Pentago.Game do
  use GenServer
  alias Pentago.Game.Board
  alias Pentago.Game.FastBoard
  alias Pentago.Algorithm.Random
  alias Pentago.Algorithm.MiniMax
  alias Pentago.Evaluator.Draw
  alias Pentago.Evaluator.Win

  @name __MODULE__

  def start_link(player1, player2) do
    GenServer.start_link(@name, {player1, player2}, name: @name)
  end

  def init({player1, player2}) do
    board = Tuple.duplicate(2, 36)

    {:ok, %{board: board, turn: 0, moves: [], player1: player1, player2: player2}}
  end

  def make_move(move) do
    GenServer.call(@name, {:make_move, move}, 100_000)
  end

  def handle_call({:make_move, %{player: :human} = move}, _from, state) do
    color = case move.color do
              :black -> 0
              :white -> 1
            end

    result = FastBoard.move(state.board, move.pos, color, move.sub_board, move.rotation)

    result(state, result)
  end

  def handle_call({:make_move, %{player: :minimax} = move}, _from, state) do
    depth = 2
    color = case move.color do
              :black -> 0
              :white -> 1
            end
    result = FastBoard.make_move(state.board, 0, color, depth, state.turn)

    result(state, result)
  end

  defp result(state, {new_board, pos, color, sub_board, rotation, winner, leafs}) do
    next_color = opposite_color(color)
    move = %{pos: pos, color: color, sub_board: sub_board, rotation: rotation}

    reply = %{
      board: format_board(new_board),
      move: move,
      color: next_color,
      player: player(state, next_color),
      winner: winner(winner)
    }
    new_state = %{
      state |
      board: new_board,
      moves: [move | state.moves],
      turn: state.turn + 1,
    }

    {:reply, reply, new_state}
  end

  defp format_board(board) do
    board
    |> Tuple.to_list
    |> Enum.map(fn color ->
      case color do
        0 -> "black"
        1 -> "white"
        2 -> "empty"
      end
    end)
  end

  defp turn_color(turn) do
    case rem(turn, 2) do
      0 -> "0"
      1 -> "1"
    end
  end

  defp winner(0), do: "black"
  defp winner(1), do: "white"
  defp winner(2), do: "empty"

  defp opposite_color(0), do: "white"
  defp opposite_color(1), do: "black"

  defp player(state, 0), do: state.player1
  defp player(state, 1), do: state.player2

  defp player(state, "black"), do: state.player1
  defp player(state, "white"), do: state.player2
end
