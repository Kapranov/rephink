use Mix.Config

config :rephink, RephinkWeb.Endpoint,
  secret_key_base: "SuNI0lmtEhmlR8B7XoGgd33If1pYVMWzt1UZEPq7e6AIC9f5gRx5ff89H37tVrSn"

config :rephink, Rephink.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "rephink_prod",
  pool_size: 15
