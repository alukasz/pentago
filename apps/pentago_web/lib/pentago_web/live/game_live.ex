defmodule Pentago.Web.GameLive do
  use Phoenix.LiveView

  def render(assigns) do
    Pentago.Web.GameView.render("live.html", assigns)
  end

  def mount(session, socket) do
    {:ok, assign(socket, board: %Pentago.Board{}, selected: nil)}
  end

  def handle_event("select_marble", position, socket) do
    IO.inspect String.to_integer(position)

    {:noreply, assign(socket, :selected, String.to_integer(position))}
  end

  def handle_event("make_move", rotation, socket) do
    {:noreply, assign(socket, :selected, nil)}
  end
end
