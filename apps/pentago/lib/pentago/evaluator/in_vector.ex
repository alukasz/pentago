defmodule Pentago.Evaluator.InVector do
  @vectors [
    [0, 1, 2, 3, 4, 5],
    [6, 7, 8, 9, 10, 11],
    [12, 13, 14, 15, 16, 17],
    [18, 19, 20, 21, 22, 23],
    [24, 25, 26, 27, 28, 29],
    [30, 31, 32, 33, 34, 35],

    [0, 6, 12, 18, 24, 30],
    [1, 7, 13, 19, 25, 31],
    [2, 8, 14, 20, 26, 32],
    [3, 9, 15, 21, 27, 33],
    [4, 10, 16, 22, 28, 34],
    [5, 11, 17, 23, 29, 35],

    [5, 10, 15, 20, 25, 30],
    [0, 7, 14, 21, 28, 35],
    [6, 13, 20, 27, 34],
    [1, 8, 15, 22, 29],
    [4, 9, 14, 19, 24],
    [11, 16, 21, 26, 31],
  ]
  @in_vector0 0
  @in_vector1 1
  @in_vector2 10
  @in_vector3 100
  @in_vector4 1000
  @in_vector5 5000
  @in_vector6 100000
  @points_value {
    {@in_vector0, -@in_vector1, -@in_vector2, -@in_vector3, -@in_vector4, -@in_vector5, -@in_vector6},
    {@in_vector1,  @in_vector0, -@in_vector1, -@in_vector2, -@in_vector3, -@in_vector4},
    {@in_vector2,  @in_vector1,  @in_vector0,  @in_vector0,  @in_vector0},
    {@in_vector3,  @in_vector2,  @in_vector0,  @in_vector0},
    {@in_vector4,  @in_vector3,  @in_vector0},
    {@in_vector5,  @in_vector4},
    {@in_vector6}
  }

  def evaluate(board), do: check_vectors(board, @vectors, 0)

  defp check_vectors(_, [], points), do: points
  defp check_vectors(board, [vector | vectors], points),
    do: check_vectors(board, vectors, points + check_vector(board, vector, 0, 0))

  defp check_vector(_, [], white, black), do: elem(elem(@points_value, black), white)
  defp check_vector(board, [pos | vector], white, black) when elem(board, pos) == :black,
    do: check_vector(board, vector, white, black + 1)
  defp check_vector(board, [pos | vector], white, black) when elem(board, pos) == :white,
    do: check_vector(board, vector, white + 1, black)
  defp check_vector(board, [_ | vector], white, black),
    do: check_vector(board, vector, white, black)
end
