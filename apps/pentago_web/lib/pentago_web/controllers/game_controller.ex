defmodule Pentago.Web.GameController do
  use Pentago.Web, :controller

  alias Pentago.Game

  def index(conn, params) do
    player1 = Map.get(params, "player1", 0)
    player2 = Map.get(params, "player2", 2)
    eval1 = Map.get(params, "eval1", 0)
    eval2 = Map.get(params, "eval2", 0)
    mg1 = Map.get(params, "mg1", 0)
    mg2 = Map.get(params, "mg2", 0)
    depth1 = Map.get(params, "depth1", 3)
    depth2 = Map.get(params, "depth2", 3)

    render conn,
      "index.html",
      player1: player1,
      player2: player2,
      eval1: eval1,
      eval2: eval2,
      mg1: mg1,
      mg2: mg2,
      depth1: depth1,
      depth2: depth2
  end

  def live(conn, params) do
    live_render conn, Pentago.Web.GameLive, session: params
  end

  def create(conn, _) do
    {:ok, %Game{id: id}} = Game.create()

    redirect conn, to: game_path(conn, :show, id)
  end

  def show(conn, %{"id" => game_id}) do
    live_render conn, Pentago.Web.GameLive, session: %{game_id: game_id}
  end
end
