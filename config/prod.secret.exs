use Mix.Config

config :rephink, RephinkWeb.Endpoint,
  secret_key_base: "60VVc7dwFc2hCTjGFcYAfaeGdKKLeVa6Dagl1+4CjwXvIFwVQu1EGwX5yyzw89Uh"

config :rephink, Rephink.Repo,
  adapter: Sqlite.Ecto2,
  database: "rephink.sqlite3"
