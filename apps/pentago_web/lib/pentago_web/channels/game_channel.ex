defmodule Pentago.Web.GameChannel do
  use Phoenix.Channel

  def join("game", _message, socket) do
    {:ok, socket}
  end
end
