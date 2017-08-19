use Mix.Config

config :rephink, RephinkWeb.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn
