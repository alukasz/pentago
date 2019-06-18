defmodule Pentago.Web.GameController do
  use Pentago.Web, :controller

  alias Pentago.Game

  def create(conn, _) do
    {:ok, %Game{id: id}} = Game.create()

    redirect conn, to: game_path(conn, :show, id)
  end

  def show(conn, %{"id" => game_id}) do
    live_render conn, Pentago.Web.GameLive, session: %{game_id: game_id}
  end
end
