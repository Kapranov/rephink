use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rephink, RephinkWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :rephink, Rephink.Repo,
  [port: 28015, host: "localhost", database: "rephink", db: "rephink"]
  #adapter: RethinkDB.Ecto,
  #database: "rephink_test",
  #hostname: "localhost",
  #port: 28015,
  #pool_size: 10
