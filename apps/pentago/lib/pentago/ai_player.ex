defmodule Pentago.AIPlayer do
  use GenServer

  alias Pentago.Board
  alias Pentago.Game

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(opts) do
    game_id = Keyword.fetch!(opts, :game_id)
    ai = Keyword.get(opts, :ai, "medium")
    send(self(), :join)

    {:ok, %{game_id: game_id, depth: depth(ai), marble: nil, board: %Board{}}}
  end

  defp depth("easy"), do: 1
  defp depth("medium"), do: 2
  defp depth("hard"), do: 3
  defp depth("impossible"), do: 4

  def handle_info(:join, %{game_id: game_id} = state) do
    case Game.join(game_id) do
      {:ok, {board, marble}} ->
        {:noreply, %{state | board: board, marble: marble}}
      {:error, reason} ->
        {:stop, :failed_to_join, state}
    end
  end

  def handle_info({:lock, _}, state) do
    {:noreply, state}
  end

  def handle_info(:make_move, state) do
    IO.inspect "MAAAAAAAAKEEEEEEEEEe MOVEEEEEEEEE"
    IO.inspect binding()
    %{game_id: game_id, depth: depth, marble: marble, board: board} = state
    move = Board.generate_move(state.board, state.marble, state.depth)
    Game.move(game_id, move)

    {:noreply, state}
  end

  def handle_info({:board, board}, state) do
    IO.inspect "BBBBBBBBBBOOOOOOOOOOOAAAAAAAARRRRRRDDDDDD"
    {:noreply, %{state | board: board}}
  end
end