defmodule Pentago.Game do
  use GenServer
  alias Pentago.Game.BitBoard

  @name __MODULE__
  @black 0
  @white 1
  @empty 2
  @human 2

  def start_link(game_state) do
    GenServer.start_link(@name, game_state, name: @name)
  end

  def close do
    GenServer.stop(@name, :shutdown)
  end

  def init(state) do
    {:ok, state}
  end

  def make_move(move) do
    GenServer.call(@name, {:make_move, move}, 10_000_000)
  end

  def handle_call({:make_move, %{color: @black} = move}, _from, %{player1: @human} = state) do
    result = BitBoard.move(state.board, move.pos, move.color, move.sub_board, move.rotation)

    result(state, result)
  end
  def handle_call({:make_move, %{color: @white} = move}, _from, %{player2: @human} = state) do
    result = BitBoard.move(state.board, move.pos, move.color, move.sub_board, move.rotation)

    result(state, result)
  end
  def handle_call({:make_move, %{color: @black}}, _from, state) do
    result = BitBoard.make_move(state.board,
      state.player1,
      state.eval1,
      state.mg1,
      @black,
      state.depth1,
      state.turn
    )

    result(state, result)
  end
  def handle_call({:make_move, %{color: @white}}, _from, state) do
    result = BitBoard.make_move(state.board,
      state.player2,
      state.eval2,
      state.mg2,
      @white,
      state.depth2,
      state.turn
    )

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
