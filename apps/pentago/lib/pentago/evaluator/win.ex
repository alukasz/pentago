defmodule Pentago.Evaluator.Win do
  @vectors [
    {0, 1, 2, 3, 4, 5},
    {6, 7, 8, 9, 10, 11},
    {12, 13, 14, 15, 16, 17},
    {18, 19, 20, 21, 22, 23},
    {24, 25, 26, 27, 28, 29},
    {30, 31, 32, 33, 34, 35},

    {0, 6, 12, 18, 24, 30},
    {1, 7, 13, 19, 25, 31},
    {2, 8, 14, 20, 26, 32},
    {3, 9, 15, 21, 27, 33},
    {4, 10, 16, 22, 28, 34},
    {5, 11, 17, 23, 29, 35},

    {5, 10, 15, 20, 25, 30},
    {0, 7, 14, 21, 28, 35},
    {6, 13, 20, 27, 34},
    {1, 8, 15, 22, 29},
    {4, 9, 14, 19, 24},
    {11, 16, 21, 26, 31},
  ]

  def evaluate(board), do: check_vectors(board, @vectors)

  defp check_vectors(_, []), do: :empty
  defp check_vectors(board, [vector | vectors]) do
    a = elem(vector, 0)
    b = elem(vector, 1)
    c = elem(vector, 2)
    d = elem(vector, 3)
    e = elem(vector, 4)

    if elem(board, b) != :empty and
       elem(board, b) == elem(board, c) and
       elem(board, c) == elem(board, d) and
       elem(board, d) == elem(board, e) and
       (elem(board, a) == elem(board, b) or
       (tuple_size(vector) == 6 and elem(board, e) == elem(board, elem(vector, 5)))) do
      elem(board, b)
    else
      check_vectors(board, vectors)
    end
  end
end
