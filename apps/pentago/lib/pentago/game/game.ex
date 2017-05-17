defmodule Pentago.Game do
  use GenServer
  alias Pentago.Game.BitBoard

  @name __MODULE__
  @minimax 0
  @alphabeta 1
  @alphabeta_sorted 2
  @black 0
  @white 1
  @empty 2

  def start_link(player1, player2, depth) do
    GenServer.start_link(@name, {player1, player2, depth}, name: @name)
  end

  def close do
    GenServer.stop(@name, :shutdown)
  end

  def init({player1, player2, depth}) do
    board = Tuple.duplicate(@empty, 36)

    {:ok, %{board: board, turn: 0, moves: [], player1: player1, player2: player2, depth: depth}}
  end

  def make_move(move) do
    GenServer.call(@name, {:make_move, move}, 10_000_000)
  end

  def handle_call({:make_move, %{player: :human} = move}, _from, state) do
    result = BitBoard.move(state.board, move.pos, move.color, move.sub_board, move.rotation)

    result(state, result)
  end

  def handle_call({:make_move, %{player: :minimax} = move}, _from, state) do
    result = BitBoard.make_move(state.board, @minimax, move.color, state.depth, state.turn)

    IO.inspect(result)
    result(state, result)
  end

  def handle_call({:make_move, %{player: :alphabeta} = move}, _from, state) do
    result = BitBoard.make_move(state.board, @alphabeta, move.color, state.depth, state.turn)

    result(state, result)
  end

  def handle_call({:make_move, %{player: :ab_sorted} = move}, _from, state) do
    result = BitBoard.make_move(state.board, @alphabeta_sorted, move.color, state.depth, state.turn)

    result(state, result)
  end

  defp result(state, {new_board, pos, color, sub_board, rotation, winner, time, leafs}) do
    next_color = opposite_color(color)
    move = %{pos: pos, color: color, sub_board: sub_board, rotation: rotation}

    reply = %{
      board: Tuple.to_list(new_board),
      move: move,
      color: next_color,
      player: player(state, next_color),
      winner: winner,
      turn: state.turn + 1,
      time: time,
      leafs: leafs
    }
    new_state = %{
      state |
      board: new_board,
      moves: [move | state.moves],
      turn: state.turn + 1,
    }

    {:reply, reply, new_state}
  end

  defp opposite_color(@black), do: @white
  defp opposite_color(@white), do: @black

  defp player(state, @black), do: state.player1
  defp player(state, @white), do: state.player2
end
