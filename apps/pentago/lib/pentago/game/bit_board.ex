defmodule Pentago.Game.BitBoard do
  @on_load :load_nifs

  def load_nifs do
    :code.priv_dir(:pentago)
    |> Path.join("libbit_board")
    |> :erlang.load_nif(0)
  end

  def move(_board, _pos, _color, _sub_board, _rotation) do
    raise "NIF move/5 not implemented"
  end

  def make_move(_board, _algorithm, _evaluation, _move_generator, _marble, _depth, _move_number) do
    raise "NIF make_move/7 not implemented"
  end
end
