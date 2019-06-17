defmodule Pentago.GameServer do
  @behaviour :gen_statem

  alias Pentago.Game
  alias Pentago.Board

  def start_link(%Game{} = game) do
    :gen_statem.start_link(Game.name(game), __MODULE__, game, [])
  end

  def init(game) do
    {:ok, :waiting, game}
  end

  def child_spec(args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [args]},
      restart: :temporary,
      type: :worker
    }
  end

  def callback_mode do
    :state_functions
  end

  def waiting({:call, from}, {:join, pid}, game) do
    IO.inspect binding()
    reply = {:reply, from, {:ok, game}}

    {:keep_state_and_data, [reply]}
  end
end
