use Mix.Config

config :rephink, RephinkWeb.Endpoint,
  secret_key_base: System.get_env("SECRET_KEY_BASE_PROD")

# Configure your database
config :rephink, Rephink.Repo,
  adapter: Sqlite.Ecto2,
  database: System.get_env("DB_PROD")
