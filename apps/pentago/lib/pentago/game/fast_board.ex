defmodule Pentago.Game.FastBoard do
  @on_load :load_nifs

  def load_nifs do
    :erlang.load_nif(__DIR__ <> "/../../../src/cmake-build-release/libpentago", 0)
  end

  def move(_board, _pos, _color, _sub_board, _rotation) do
    raise "NIF move/5 not implemented"
  end

  def make_move(_board, _pos, _color, _sub_board, _rotation) do
    raise "NIF next_move/1 not implemented"
  end

  def points_in_rows(_board) do
    raise "NIF points_in_rows/1 not implemented"
  end

  def points_in_vectors(_board) do
    raise "NIF points_in_vectors/1 not implemented"
  end

  def win(_board) do
    raise "NIF points_in_win/1 not implemented"
  end

end
