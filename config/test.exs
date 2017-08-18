use Mix.Config

config :rephink, RephinkWeb.Endpoint,
  http: [port: System.get_env("TEST_PORT")],
  server: false

config :logger, level: :warn

config :rephink, :ecto_adapter, Sqlite.Ecto2

config :rephink, Rephink.Repo,
  adapter: Application.get_env(:rephink, :ecto_adapter),
  database: System.get_env("DB_TEST"),
  pool: Ecto.Adapters.SQL.Sandbox,
  size: 1,
  max_overflow: 0
