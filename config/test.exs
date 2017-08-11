use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rephink, RephinkWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database for dev and test env
config :rephink, :ecto_adapter, Sqlite.Ecto2

config :rephink, Rephink.Repo,
  adapter: Application.get_env(:rephink, :ecto_adapter),
  database: "test/rephink_test.sqlite3",
  pool: Ecto.Adapters.SQL.Sandbox,
  size: 1,
  max_overflow: 0
