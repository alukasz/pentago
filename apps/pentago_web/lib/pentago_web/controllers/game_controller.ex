defmodule Pentago.Web.GameController do
  use Pentago.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
