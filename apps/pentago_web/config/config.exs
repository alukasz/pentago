# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :pentago_web,
  namespace: Pentago.Web

# Configures the endpoint
config :pentago_web, Pentago.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "33g+LdE/mvFTHyDqVQ79YYuUEpUcaF9TfAlZh3tf/e+OB5hkrvww5sEh6Jjv/jCK",
  render_errors: [view: Pentago.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Pentago.Web.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "RQvXohxbvuutBcaleUfeUWpDdjp9hjsm"
  ]

config :phoenix, :json_library, Jason

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
