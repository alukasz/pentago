defmodule Pentago.Web.GameView do
  use Pentago.Web, :view

  alias Pentago.Board

  def finished?(%Board{moves_history: history}) when length(history) == 36, do: true
  def finished?(%Board{winner: :empty}), do: false
  def finished?(_), do: true

  def winner_message(%Board{winner: marble}, marble), do: "You won!"
  def winner_message(%Board{winner: :empty}, _), do: "Draw"
  def winner_message(%Board{winner: :draw}, _), do: "Draw"
  def winner_message(%Board{winner: _}, _), do: "Second place"


  def player_color(:empty), do: ""

  def player_color(color) do
    ["Your marble:", content_tag(:span, "", class: "marble " <> color(color))]
  end

  def lock_board(message) do
    content_tag :div, class: "lock" do
      content_tag :p, message
    end
  end

  def board(%Board{marbles: marbles} = b, selected) do
    marbles
    |> Enum.with_index()
    |> Enum.chunk_every(6)
    |> Enum.map(&board_row(&1, selected))
  end

  defp board_row(marbles, selected) do
    content_tag :div, class: "marble-row" do
      Enum.map(marbles, &marble(&1, selected))
    end
  end

  defp marble({marble, position}, selected) when marble in [:black, :white, :empty] do
    class = Enum.join(["marble", color(marble), selected(position, selected)], " ")
    action =
      case marble do
        :empty -> ["phx-click": "select_marble", "phx-value": position]
        _ -> []
      end

    content_tag(:div, nil, [class: class] ++ action)
  end

  defp color(:black), do: "marble-black"
  defp color(:white), do: "marble-white"
  defp color(:empty), do: "marble-empty"

  defp selected(position, position), do: "marble-selected"
  defp selected(_, _), do: ""

  def rotate_button(sub_board, rotation) do
    class = "rotate rotate-#{sub_board}-#{rotation}"
    content_tag(:button, nil, class: class, "phx-click": "make_move", "phx-value": [sub_board, "-", rotation])
  end
end
