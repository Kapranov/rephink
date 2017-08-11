use Mix.Config

# General application configuration
config :rephink,
  ecto_repos: [Rephink.Repo]

# Configures the repo
config :rephink, Rephink.Repo,
  adapter: Sqlite.Ecto2,
  database: "rephink.sqlite3"

# Configures the endpoint
config :rephink, RephinkWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "IGz0rvc1S5H+DUo9SLeG1Rc1U0OCdkSXs112t8VpBvf0YTMP9R/5H44IO2wZl7BR",
  render_errors: [view: RephinkWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Rephink.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures schema and migration
config :rephink, :generators,
  migration: true,
  binary_id: true,
  sample_binary_id: "11111111-1111-1111-1111-111111111111"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
