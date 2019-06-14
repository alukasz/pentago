defmodule Pentago.Web.GameView do
  use Pentago.Web, :view

  alias Pentago.Board

  def board(%Board{marbles: marbles}, selected) do
    marbles
    |> Enum.with_index()
    |> Enum.chunk(6)
    |> Enum.map(&board_row(&1, selected))
  end

  defp board_row(marbles, selected) do
    content_tag :div, class: "marble-row" do
      Enum.map(marbles, &marble(&1, selected))
    end
  end

  defp marble({marble, position}, selected) when marble in [:black, :white, :empty] do
    class = Enum.join(["marble", color(marble), selected(position, selected)], " ")
    content_tag(:div, nil, class: class, "phx-click": "select_marble", "phx-value": position)
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
