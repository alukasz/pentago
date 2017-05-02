defmodule Pentago.Application do
  @moduledoc """
  The Pentago Application Service.

  The pentago system business domain lives in this application.

  Exposes API to clients such as the `Pentago.Web` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([

    ], strategy: :one_for_one, name: Pentago.Supervisor)
  end
end
