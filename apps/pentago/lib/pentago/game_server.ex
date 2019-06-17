defmodule Pentago.GameServer do
  @behaviour :gen_statem

  require Logger

  alias Pentago.Game
  alias Pentago.Board

  def start_link(%Game{} = game) do
    :gen_statem.start_link(Game.name(game), __MODULE__, game, [])
  end

  def child_spec(args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [args]},
      restart: :temporary,
      type: :worker
    }
  end

  def init(game) do
    Logger.debug "creating game #{game.id}"
    {:ok, :waiting, game}
  end

  def callback_mode do
    :state_functions
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

  defp join(game, player, {pid, _} = from) do
    Logger.debug("#{player} #{inspect pid} is joining game #{game.id}")
    game = Map.put(game, player, pid)
    Process.monitor(pid)
    maybe_start_game()
    {:keep_state, game, [{:reply, from, {:ok, game}}]}
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

  def waiting(:info, {:DOWN, _, _, pid, _}, %{player1: pid} = game) do
    Logger.debug "Player 1 #{inspect pid} disconnected"
    maybe_terminate()
    {:keep_state, %{game | player1: nil}}
  end

  def waiting(:info, {:DOWN, _, _, pid, _}, %{player2: pid} = game) do
    Logger.debug "Player 2 #{inspect pid} disconnected"
    maybe_terminate()
    {:keep_state, %{game | player2: nil}}
  end

  def playing(:info, {:DOWN, _, _, pid, _}, %{player1: pid} = game) do
    Logger.debug "Player 1 #{inspect pid} disconnected"
    maybe_terminate()
    {:next_state, :waiting, %{game | player1: nil}}
  end

  def playing(:info, {:DOWN, _, _, pid, _}, %{player2: pid} = game) do
    Logger.debug "Player 2 #{inspect pid} disconnected"
    maybe_terminate()
    {:next_state, :waiting, %{game | player2: nil}}
  end

  defp maybe_start_game do
    send(self(), :maybe_start_game)
  end

  defp maybe_terminate do
    send(self(), :maybe_terminate)
  end
end
