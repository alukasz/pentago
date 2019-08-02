defmodule Pentago.Web.GameView do
  use Pentago.Web, :view

  alias Pentago.Board

  def result_message(:won), do: "You won!"
  def result_message(:lost), do: "Second place"
  def result_message(:no_winner), do: "No winner"
  def result_message(:draw), do: "Draw"

  def player_color(:empty), do: ""

  def player_color(color) do
    ["Your marble:", content_tag(:span, "", class: "marble " <> color(color))]
  end

  def lock_board(message) do
    content_tag :div, class: "lock" do
      content_tag(:p, message)
    end
  end

  def board(%Board{marbles: marbles}, selected) do
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

  def rotate_button(sub_board, rotation, nil) do
    class = "rotate rotate-#{sub_board}-#{rotation}"
    content_tag(:button, nil, class: class)
  end

  def rotate_button(sub_board, rotation, _selected) do
    class = "rotate rotate-#{sub_board}-#{rotation}"

    content_tag(:button, nil,
      class: class,
      "phx-click": "make_move",
      "phx-value": [sub_board, "-", rotation]
    )
  end
end
