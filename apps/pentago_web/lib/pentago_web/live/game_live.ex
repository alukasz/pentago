defmodule Pentago.Web.GameLive do
  use Phoenix.LiveView
  alias Pentago.Game

  @default_assigns %{
    board: %Pentago.Board{},
    marble: :empty,
    selected: nil,
    make_move: false,
    lock: "Loading...",
    result: false
  }

  def render(assigns) do
    Pentago.Web.GameView.render("show.html", assigns)
  end

  def mount(%{game_id: game_id, ai: ai}, socket) do
    if Game.exists?(game_id) do
      send(self(), {:join, game_id})
      send(self(), {:start_ai, ai})
      {:ok, assign(socket, @default_assigns)}
    else
      {:ok, assign(socket, Map.put(@default_assigns, :lock, "Game does not exists"))}
    end
  end

  def handle_event("select_marble", position, socket) do
    {:noreply, assign(socket, :selected, String.to_integer(position))}
  end

  def handle_event("make_move", sub_board_rotation, socket) do
    %{marble: marble, selected: selected} = socket.assigns

    case selected do
      nil ->
        {:noreply, assign(socket, selected: nil)}

      _ ->
        move = build_move(marble, selected, sub_board_rotation)
        Game.move(socket.assigns.game_id, move)
        {:noreply, assign(socket, selected: nil, make_move: false)}
    end
  end

  def handle_info({:join, game_id}, socket) do
    case Game.join(game_id) do
      {:ok, marble} ->
        {:noreply,
         assign(socket, game_id: game_id, marble: marble, lock: "Waiting for other player")}

      {:error, reason} ->
        {:noreply, assign(socket, :lock, reason)}
    end
  end

  def handle_info({:start_ai, nil}, socket) do
    {:noreply, socket}
  end

  def handle_info({:start_ai, ai}, socket) do
    {:ok, _} = Pentago.AIPlayer.start_link(game_id: socket.assigns.game_id, ai: ai)
    {:noreply, socket}
  end

  def handle_info({:lock, message}, socket) do
    {:noreply, assign(socket, lock: message, make_move: false)}
  end

  def handle_info(:make_move, socket) do
    {:noreply, assign(socket, lock: false, make_move: true)}
  end

  def handle_info({:board, board}, socket) do
    {:noreply, assign(socket, :board, board)}
  end

  def handle_info({:result, result}, socket) do
    {:noreply, assign(socket, :result, result)}
  end

  defp build_move(marble, position, sub_board_rotation) do
    [sub_board, rotation] = String.split(sub_board_rotation, "-")

    %Pentago.Move{
      marble: marble,
      position: position,
      sub_board: String.to_existing_atom(sub_board),
      rotation: String.to_existing_atom(rotation)
    }
  end
end
