defmodule Pentago.Game do
  alias Pentago.Board
  alias Pentago.Game
  alias Pentago.GameServer

  defstruct [
    :id,
    :player1,
    :player2,
    next_player: :player1,
    board: %Board{},
  ]

  def create do
    game = %__MODULE__{id: generate_id()}
    {:ok, _} = DynamicSupervisor.start_child(Pentago.GameSupervisor, {GameServer, game})

    {:ok, game}
  end

  def join(game) do
    :gen_statem.call(name(game), {:join, self()})
  end

  def name(%Game{id: id}), do: name(id)
  def name(id), do: {:via, Registry, {Pentago.GameRegistry, id}}

  defp generate_id do
    :crypto.strong_rand_bytes(6)
    |> Base.encode16()
    |> String.downcase()
  end
end
