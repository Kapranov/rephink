use Mix.Config

config :rephink, RephinkWeb.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn

config :rephink, :ecto_adapter, Sqlite.Ecto2

config :rephink, Rephink.Repo,
  adapter: Application.get_env(:rephink, :ecto_adapter),
  database: "test/rephink_test.sqlite3",
  pool: Ecto.Adapters.SQL.Sandbox,
  size: 1,
  max_overflow: 0
