use Mix.Config

config :rephink,
  ecto_repos: [Rephink.Repo]

config :rephink, Rephink.Repo,
  adapter: Sqlite.Ecto2,
  database: System.get_env("DB_DEV")

config :rephink, RephinkWeb.Endpoint,
  url: [host: System.get_env("HOSTNAME"), port: {:system, "PORT"}],
  http: [port: System.get_env("PORT") || 4000],
  secret_key_base: System.get_env("SECRET_KEY_BASE")
  render_errors: [view: RephinkWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Rephink.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :rephink, :generators,
  migration: true,
  binary_id: false,
  sample_binary_id: "11111111-1111-1111-1111-111111111111"

import_config "#{Mix.env}.exs"
