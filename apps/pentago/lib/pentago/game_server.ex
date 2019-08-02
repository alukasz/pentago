defmodule Pentago.GameServer do
  @behaviour :gen_statem

  require Logger

  alias Pentago.Game
  alias Pentago.Board

  def init(game) do
    {:ok, :waiting, game}
  end

  def callback_mode do
    [:state_functions, :state_enter]
  end

  # :waiting callbacks

  def waiting(:enter, _, _game) do
    :keep_state_and_data
  end

  def waiting({:call, from}, :join, %{player1: nil} = game) do
    join(game, :player1, from)
  end

  def waiting({:call, from}, :join, %{player2: nil} = game) do
    join(game, :player2, from)
  end

  def waiting(:info, :start_game, %{player1: nil}), do: :keep_state_and_data
  def waiting(:info, :start_game, %{player2: nil}), do: :keep_state_and_data
  def waiting(:info, :start_game, game), do: {:next_state, :playing, game}

  def waiting(:info, {:DOWN, _, _, _, _}, game) do
    {:stop, :players_disconnected, game}
  end

  # :playing callbacks

  def playing(:enter, _, %{current_player: :player1} = game) do
    lock_board(game.player2, "Player 1 is making move")
    ask_for_move(game.player1)

    :keep_state_and_data
  end

  def playing(:enter, _, %{current_player: :player2} = game) do
    lock_board(game.player1, "Player 2 is making move")
    ask_for_move(game.player2)

    :keep_state_and_data
  end

  def playing({:call, from}, :join, _game) do
    {:keep_state_and_data, [{:reply, from, {:error, "Game full"}}]}
  end

  # block player1 tampering with game and making move in player2 turn
  def playing(:cast, {:move, _, player}, %{current_player: :player2, player1: player}) do
    :keep_state_and_data
  end

  # block player2 tampering with game and making move in player1 turn
  def playing(:cast, {:move, _, player}, %{current_player: :player1, player2: player}) do
    :keep_state_and_data
  end

  def playing(:cast, {:move, move, _player_pid}, game) do
    game = %{game | board: Board.move(game.board, move)}
    send_board(game)

    case Board.winner(game.board) do
      :in_progress ->
        next_player = opposite_player(game.current_player)
        {:repeat_state, %{game | current_player: next_player}}

      result ->
        notify_result(game, result)
        {:keep_state, game}
    end
  end

  # handle player disconnecting when playing

  def playing(:info, {:DOWN, _, _, pid, _}, %{player1: pid} = game) do
    lock_board(game, "Waiting for player 1 to reconnect")
    {:next_state, :waiting, %{game | player1: nil}}
  end

  def playing(:info, {:DOWN, _, _, pid, _}, %{player2: pid} = game) do
    lock_board(game, "Waiting for player 2 to reconnect")
    {:next_state, :waiting, %{game | player2: nil}}
  end

  # helpers

  defp join(game, player, {pid, _} = from) do
    game = Map.put(game, player, pid)
    Process.monitor(pid)
    start_game()
    send_board(game)
    {:keep_state, game, [{:reply, from, {:ok, player_color(player)}}]}
  end

  defp notify_result(game, :draw), do: send_result(game, :draw)
  defp notify_result(game, :no_winner), do: send_result(game, :no_winner)

  defp notify_result(%{player1: player1, player2: player2}, :black) do
    send_result(player1, :won)
    send_result(player2, :lost)
  end

  defp notify_result(%{player1: player1, player2: player2}, :white) do
    send_result(player1, :lost)
    send_result(player2, :won)
  end

  defp player_color(:player1), do: :black
  defp player_color(:player2), do: :white

  defp opposite_player(:player1), do: :player2
  defp opposite_player(:player2), do: :player1

  # schedule helpers

  defp start_game do
    send(self(), :start_game)
  end

  # updating live view helpers

  defp lock_board(game_or_pid, message) do
    send_live(game_or_pid, {:lock, message})
  end

  defp ask_for_move(pid) when is_pid(pid) do
    send_live(pid, :make_move)
  end

  defp send_board(%{board: board} = game) do
    send_live(game, {:board, board})
  end

  defp send_result(game_or_pid, result) do
    send_live(game_or_pid, {:result, result})
  end

  defp send_live(%Game{player1: pid1, player2: pid2}, message) do
    send_live([pid1, pid2], message)
  end

  defp send_live(pids, message) do
    for pid <- List.wrap(pids), is_pid(pid) do
      send(pid, message)
    end
  end
end
