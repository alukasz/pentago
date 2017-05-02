defmodule Pentago.Game.Board do
  @rows 6
  @size 36

  def new do
    Tuple.duplicate(:empty, @size)
  end

  def move(board, {pos, color, sub_board, rotation} = move) do
    new_board = put_elem(board, pos, color)
    rotate(new_board, sub_board, rotation)
  end

  # put_elem/3 optimization
  # http://erlang.org/doc/efficiency_guide/commoncaveats.html#id61742
  defp rotate(board, 0, :clockwise) do
    a = elem(board, 0)
    b = elem(board, 1)
    c = elem(board, 2)
    d = elem(board, 6)
    e = elem(board, 8)
    f = elem(board, 12)
    g = elem(board, 13)
    h = elem(board, 14)

    t = put_elem(board, 14, c)
    t = put_elem(t, 13, e)
    t = put_elem(t, 8, b)
    t = put_elem(t, 7, h)
    t = put_elem(t, 6, g)
    t = put_elem(t, 2, a)
    t = put_elem(t, 1, d)
    put_elem(t, 0, f)
  end
  defp rotate(board, 0, :counter_clockwise) do
    a = elem(board, 0)
    b = elem(board, 1)
    c = elem(board, 2)
    d = elem(board, 6)
    e = elem(board, 8)
    f = elem(board, 12)
    g = elem(board, 13)
    h = elem(board, 14)

    t = put_elem(board, 14, f)
    t = put_elem(t, 13, d)
    t = put_elem(t, 12, a)
    t = put_elem(t, 8, g)
    t = put_elem(t, 6, b)
    t = put_elem(t, 2, h)
    t = put_elem(t, 1, e)
    put_elem(t, 0, c)
  end
  defp rotate(board, 1, :clockwise) do
    a = elem(board, 3)
    b = elem(board, 4)
    c = elem(board, 5)
    d = elem(board, 9)
    e = elem(board, 11)
    f = elem(board, 15)
    g = elem(board, 16)
    h = elem(board, 17)

    t = put_elem(board, 17, c)
    t = put_elem(t, 16, e)
    t = put_elem(t, 15, b)
    t = put_elem(t, 11, h)
    t = put_elem(t, 9, g)
    t = put_elem(t, 5, a)
    t = put_elem(t, 4, d)
    put_elem(t, 3, f)
  end
  defp rotate(board, 1, :counter_clockwise) do
    a = elem(board, 3)
    b = elem(board, 4)
    c = elem(board, 5)
    d = elem(board, 9)
    e = elem(board, 11)
    f = elem(board, 15)
    g = elem(board, 16)
    h = elem(board, 17)

    t = put_elem(board, 17, f)
    t = put_elem(t, 16, d)
    t = put_elem(t, 15, a)
    t = put_elem(t, 11, g)
    t = put_elem(t, 9, b)
    t = put_elem(t, 5, h)
    t = put_elem(t, 4, e)
    put_elem(t, 3, c)
  end
  defp rotate(board, 2, :clockwise) do
    a = elem(board, 18)
    b = elem(board, 19)
    c = elem(board, 20)
    d = elem(board, 24)
    e = elem(board, 26)
    f = elem(board, 30)
    g = elem(board, 31)
    h = elem(board, 32)

    t = put_elem(board, 32, c)
    t = put_elem(t, 31, e)
    t = put_elem(t, 30, b)
    t = put_elem(t, 26, h)
    t = put_elem(t, 24, g)
    t = put_elem(t, 20, a)
    t = put_elem(t, 19, d)
    put_elem(t, 18, f)
  end
  defp rotate(board, 2, :counter_clockwise) do
    a = elem(board, 18)
    b = elem(board, 19)
    c = elem(board, 20)
    d = elem(board, 24)
    e = elem(board, 26)
    f = elem(board, 30)
    g = elem(board, 31)
    h = elem(board, 32)

    t = put_elem(board, 32, f)
    t = put_elem(t, 31, d)
    t = put_elem(t, 30, a)
    t = put_elem(t, 26, g)
    t = put_elem(t, 24, b)
    t = put_elem(t, 20, h)
    t = put_elem(t, 19, e)
    put_elem(t, 18, c)
  end
  defp rotate(board, 3, :clockwise) do
    a = elem(board, 21)
    b = elem(board, 22)
    c = elem(board, 23)
    d = elem(board, 27)
    e = elem(board, 29)
    f = elem(board, 33)
    g = elem(board, 34)
    h = elem(board, 35)

    t = put_elem(board, 35, c)
    t = put_elem(t, 34, e)
    t = put_elem(t, 33, b)
    t = put_elem(t, 29, h)
    t = put_elem(t, 27, g)
    t = put_elem(t, 23, a)
    t = put_elem(t, 22, d)
    put_elem(t, 21, f)
  end
  defp rotate(board, 3, :counter_clockwise) do
    a = elem(board, 21)
    b = elem(board, 22)
    c = elem(board, 23)
    d = elem(board, 27)
    e = elem(board, 29)
    f = elem(board, 33)
    g = elem(board, 34)
    h = elem(board, 35)

    t = put_elem(board, 35, f)
    t = put_elem(t, 34, d)
    t = put_elem(t, 33, a)
    t = put_elem(t, 29, g)
    t = put_elem(t, 27, b)
    t = put_elem(t, 23, h)
    t = put_elem(t, 22, e)
    put_elem(t, 21, c)
  end
end
