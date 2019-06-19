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

  def waiting({:call, {pid, _} = from}, :join, game) do
    {:keep_state_and_data, [{:reply, from, {:error, :game_full}}]}
  end

  def waiting(:info, :start_game, %{player1: nil}), do: :keep_state_and_data
  def waiting(:info, :start_game, %{player2: nil}), do: :keep_state_and_data
  def waiting(:info, :start_game, game), do: {:next_state, :playing, game}

  def waiting(:info, :terminate, %{player1: nil, player2: nil} = game) do
    {:stop, :players_disconnected, game}
  end

  def waiting(:info, :terminate, _game) do
    :keep_state_and_data
  end

  # handle player disconnecting

  def waiting(:info, {:DOWN, _, _, pid, _}, %{player1: pid} = game) do
    lock_board(game, "Waiting for player 1 to reconnect")
    terminate()
    {:keep_state, %{game | player1: nil}}
  end

  def waiting(:info, {:DOWN, _, _, pid, _}, %{player2: pid} = game) do
    lock_board(game, "Waiting for player 2 to reconnect")
    terminate()
    {:keep_state, %{game | player2: nil}}
  end

  # :playing callbacks

  def playing(:enter, _, game) do
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
    game = %{game | board: board}
    update_board(game)
    case result(game) do
      :nope ->
        {:repeat_state, %{game | current_player: opposite_player(game.current_player)}}

      result ->
        notify_result(game, result)
        {:keep_state, game}
    end
  end

  # handle player disconnecting when playing

  def playing(:info, {:DOWN, _, _, pid, _}, %{player1: pid} = game) do
    lock_board(game, "Waiting for player 1 to reconnect")
    terminate()
    {:next_state, :waiting, %{game | player1: nil}}
  end

  def playing(:info, {:DOWN, _, _, pid, _}, %{player2: pid} = game) do
    lock_board(game, "Waiting for player 2 to reconnect")
    terminate()
    {:next_state, :waiting, %{game | player2: nil}}
  end

  # helpers

  defp join(game, player, {pid, _} = from) do
    game = Map.put(game, player, pid)
    Process.monitor(pid)
    start_game()
    reply = {:reply, from, {:ok, {game.board, player_color(player)}}}
    {:keep_state, game, [reply]}
  end

  defp result(%{board: %{winner: winner, moves_history: history}} = game) do
    cond do
      winner == :draw ->
        :draw

      length(history) == 36 and winner == :empty ->
        :empty

      winner in [:black, :white] ->
        player(winner)

      true -> :nope
    end
  end

  defp notify_result(%{player1: player1, player2: player2} = game, result) do
    case result do
      :draw ->
        send_result(game, :draw)

      :empty ->
        send_result(game, :empty)

      :player1 ->
        send_result(player1, :won)
        send_result(player2, :lost)

      :player2 ->
        send_result(player1, :lost)
        send_result(player2, :won)
    end
  end

  defp player_color(:player1), do: :black
  defp player_color(:player2), do: :white

  defp opposite_player(:player1), do: :player2
  defp opposite_player(:player2), do: :player1

  defp player(:black), do: :player1
  defp player(:white), do: :player2

  def finished?(%Board{moves_history: history}) when length(history) == 36, do: true
  def finished?(%Board{winner: :empty}), do: false
  def finished?(_), do: true

  def winner_message(%Board{winner: marble}, marble), do: "You won!"
  def winner_message(%Board{winner: :empty}, _), do: "Draw"
  def winner_message(%Board{winner: :draw}, _), do: "Draw"
  def winner_message(%Board{winner: _}, _), do: "Second place"

  # schedule helpers

  defp start_game do
    send(self(), :start_game)
  end

  defp terminate do
    send(self(), :terminate)
  end

  # updating live view helpers

  defp lock_board(game_or_pid, message) do
    send_live(game_or_pid, {:lock, message})
  end

  defp ask_for_move(pid) when is_pid(pid) do
    send_live(pid, :make_move)
  end

  defp update_board(%{board: board} = game) do
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
