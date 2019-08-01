defmodule Pentago.Web.GameChannel do
  use Phoenix.Channel

  alias Pentago.Game

  def join("game:" <> game_id, _payload, socket) do
    send(self(), :join)

    {:ok, assign(socket, :game_id, game_id)}
  end

  def handle_in("make_move", payload, socket) do
    %{"position" => position, "rotation" => rotation, "sub_board" => sub_board} = payload
    move = build_move(socket.assigns.marble, position, rotation, sub_board)
    Game.move(socket.assigns.game_id, move)

    {:noreply, socket}
  end

  def handle_info(:join, socket) do
    case Game.join(socket.assigns.game_id) do
      {:ok, marble} ->
        push socket, "init", %{marble: marble, lock: "Waiting for other player"}
        {:noreply, assign(socket, :marble, marble)}
      {:error, reason} ->
        push socket, "lock", %{lock: reason}
        {:noreply, socket}
    end

  end

  def handle_info({:lock, message}, socket) do
    push socket, "lock", %{lock: message}

    {:noreply, socket}
  end

  def handle_info(:make_move, socket) do
    push socket, "make_move", %{}

    {:noreply, socket}
  end

  def handle_info({:board, board}, socket) do
    push socket, "board", %{board: board.marbles}

    {:noreply, socket}
  end

  def handle_info({:result, result}, socket) do
    push socket, "result", %{result: result}

    {:noreply, socket}
  end

  defp build_move(marble, position, rotation, sub_board) do
    %Pentago.Move{
      marble: marble,
      position: position,
      sub_board: String.to_existing_atom(sub_board),
      rotation: String.to_existing_atom(rotation)
    }
  end
end
