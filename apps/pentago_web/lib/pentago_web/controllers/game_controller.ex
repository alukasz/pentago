defmodule Pentago.Web.GameController do
  use Pentago.Web, :controller

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
end
