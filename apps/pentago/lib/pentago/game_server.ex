defmodule Pentago.GameServer do
  @behaviour :gen_statem

  require Logger

  alias Pentago.Game
  alias Pentago.Board

  def init(game) do
    Logger.debug "creating game #{game.id}"
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

  def waiting({:call, {pid, _} = from}, :join, game) do
    Logger.debug("player #{inspect pid} cannot join full game #{game.id}")
    {:keep_state_and_data, [{:reply, from, {:error, :game_full}}]}
  end

  def waiting(:info, :maybe_start_game, %{player1: nil}), do: :keep_state_and_data
  def waiting(:info, :maybe_start_game, %{player2: nil}), do: :keep_state_and_data

  def waiting(:info, :maybe_start_game, game) do
    Logger.debug "starting game"
    {:next_state, :playing, game}
  end

  def waiting(:info, :maybe_terminate, %{player1: nil, player2: nil} = game) do
    Logger.debug "terminating game #{game.id}"
    {:stop, :players_disconnected, game}
  end

  def waiting(:info, :maybe_terminate, _game) do
    :keep_state_and_data
  end

  # handle player disconnecting

  def waiting(:info, {:DOWN, _, _, pid, _}, %{player1: pid} = game) do
    Logger.debug "Player 1 #{inspect pid} disconnected"
    lock_board(game, "Waiting for player 1 to reconnect")
    maybe_terminate()
    {:keep_state, %{game | player1: nil}}
  end

  def waiting(:info, {:DOWN, _, _, pid, _}, %{player2: pid} = game) do
    Logger.debug "Player 2 #{inspect pid} disconnected"
    lock_board(game, "Waiting for player 2 to reconnect")
    maybe_terminate()
    {:keep_state, %{game | player2: nil}}
  end

  # :playing callbacks

  def playing(:enter, _, game) do
    Logger.debug "enter playing"
    case game.current_player do
      :player1 ->
        lock_board(game.player2, "Player 1 is making move")
        ask_for_move(game.player1)

      :player2 ->
        lock_board(game.player1, "Player 2 is making move")
        ask_for_move(game.player2)
    end
    :keep_state_and_data
  end

  def playing(:cast, {:move, move}, game) do
    board = Board.move(game.board, move)
    game = %{game | board: board, current_player: next_player(game.current_player)}
    update_board(game)

    {:repeat_state, game}
  end

  # handle player disconnecting when playing

  def playing(:info, {:DOWN, _, _, pid, _}, %{player1: pid} = game) do
    Logger.debug "Player 1 #{inspect pid} disconnected"
    lock_board(game, "Waiting for player 1 to reconnect")
    maybe_terminate()
    {:next_state, :waiting, %{game | player1: nil}}
  end

  def playing(:info, {:DOWN, _, _, pid, _}, %{player2: pid} = game) do
    Logger.debug "Player 2 #{inspect pid} disconnected"
    lock_board(game, "Waiting for player 2 to reconnect")
    maybe_terminate()
    {:next_state, :waiting, %{game | player2: nil}}
  end

  # helpers

  defp join(game, player, {pid, _} = from) do
    Logger.debug("#{player} #{inspect pid} is joining game #{game.id}")
    game = Map.put(game, player, pid)
    Process.monitor(pid)
    maybe_start_game()
    reply = {:reply, from, {:ok, {game.board, player_color(player)}}}
    {:keep_state, game, [reply]}
  end

  defp player_color(:player1), do: :black
  defp player_color(:player2), do: :white

  defp next_player(:player1), do: :player2
  defp next_player(:player2), do: :player1

  # schedule helpers

  defp maybe_start_game do
    send(self(), :maybe_start_game)
  end

  defp maybe_terminate do
    send(self(), :maybe_terminate)
  end

  # updating live view helpers

  defp lock_board(game, message) do
    send_live(game, {:lock, message})
  end

  defp ask_for_move(pid) do
    send_live(pid, :make_move)
  end

  defp update_board(%{board: board} = game) do
    send_live(game, {:board, board})
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
