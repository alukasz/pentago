import Config

config :pentago_web, Pentago.Web.Endpoint,
  server: true,
  url: [host: System.get_env("APP_NAME") <> ".gigalixirapp.com", port: 443]
