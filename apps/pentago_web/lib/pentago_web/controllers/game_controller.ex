defmodule Pentago.Web.GameController do
  use Pentago.Web, :controller

  @available_players ["minimax", "human", "random"]

  def index(conn, params) do
    player1 = Map.get(params, "player1", "minimax")
    player2 = Map.get(params, "player2", "human")

    unless player1 in @available_players do
      player1 = "minimax"
    end
    unless player2 in @available_players do
      player2 = "human"
    end

    render conn, "index.html", player1: player1, player2: player2
  end
end
