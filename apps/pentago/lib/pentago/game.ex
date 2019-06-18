defmodule Pentago.Game do
  alias Pentago.Board
  alias Pentago.Game
  alias Pentago.GameServer
  alias Pentago.Move

  defstruct [
    :id,
    :player1,
    :player2,
    current_player: :player1,
    board: %Board{},
  ]

  def create do
    game = %__MODULE__{id: generate_id()}
    {:ok, _} = DynamicSupervisor.start_child(Pentago.GameSupervisor, {GameServer, game})

    {:ok, game}
  end

  def exists?(%Game{id: id}), do: exists?(id)

  def exists?(id) do
    case Registry.lookup(Pentago.GameRegistry, id) do
      [{_, _}] -> true
      _ -> false
    end
  end

  def join(game) do
    :gen_statem.call(name(game), :join)
  end

  def move(game, %Move{} = move) do
    :gen_statem.cast(name(game), {:move, move})
  end

  def name(%Game{id: id}), do: name(id)
  def name(id), do: {:via, Registry, {Pentago.GameRegistry, id}}

  defp generate_id do
    :crypto.strong_rand_bytes(6)
    |> Base.encode16()
    |> String.downcase()
  end
end
