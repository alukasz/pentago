# defmodule Pentago.Game do
#   @behaviour :gen_statem

#   alias Pentago.Game

#   def new do
#     id = :crypto.strong_rand_bytes(32) |> Base.encode16 |> binary_part(0, 32)

#     %Game{id: id}
#   end
# end
