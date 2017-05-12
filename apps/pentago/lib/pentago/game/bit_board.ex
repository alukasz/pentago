defmodule Pentago.Game.BitBoard do
  @moduledoc """
  When fast board is not enough.
  """
  @on_load :load_nifs

  def load_nifs do
    :erlang.load_nif(__DIR__ <> "/../../../src/cmake-build-release/libbit_board", 0)
  end

  def move(_board, _pos, _color, _sub_board, _rotation) do
    raise "NIF move/5 not implemented"
  end

  def make_move(_board, _pos, _color, _sub_board, _rotation) do
    raise "NIF next_move/1 not implemented"
  end
end
