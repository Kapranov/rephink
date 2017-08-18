use Mix.Config

config :rephink, RephinkWeb.Endpoint,
  secret_key_base: "GwzWOyetVwDLhN4LHBVfV6eaLmq2N9wbXIBBsTb3JJ+YX913hEelFyawJRAy2YON"

# Configure your database
config :rephink, Rephink.Repo,
  adapter: Sqlite.Ecto2,
  database: System.get_env("DB_PROD")
