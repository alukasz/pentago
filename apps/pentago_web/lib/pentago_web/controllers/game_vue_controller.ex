defmodule Pentago.Web.GameVueController do
  use Pentago.Web, :controller

  alias Pentago.Game

  def create(conn, _params) do
    {:ok, %Game{id: id}} = Game.create()

    redirect conn, to: game_vue_path(conn, :show, id)
  end

  def show(conn, %{"id" => id}) do
    render conn, "show.html", game_id: id
  end
end
