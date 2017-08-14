# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
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
  secret_key_base: "niENFexfh3crwGnOVw3SU0wniK641P6DkcCevv4b8Z5DHA+Sgs76jHrkeIvQXBj7",
  render_errors: [view: RephinkWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Rephink.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
