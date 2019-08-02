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

  def start_link(%Game{} = game) do
    :gen_statem.start_link(name(game), GameServer, game, [])
  end

  def child_spec(args) do
    %{
      id: Game,
      start: {Game, :start_link, [args]},
      restart: :temporary,
      type: :worker
    }
  end

  def create do
    game = %__MODULE__{id: generate_id()}
    {:ok, _} = DynamicSupervisor.start_child(Pentago.GameSupervisor, {Game, game})

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
    :gen_statem.cast(name(game), {:move, move, self()})
  end

  defp name(%Game{id: id}), do: name(id)
  defp name(id), do: {:via, Registry, {Pentago.GameRegistry, id}}

  defp generate_id do
    :crypto.strong_rand_bytes(6)
    |> Base.encode16()
    |> String.downcase()
  end
end
