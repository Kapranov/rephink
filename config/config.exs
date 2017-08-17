use Mix.Config

config :rephink,
  ecto_repos: [Rephink.Repo]

config :rephink, Rephink.Repo,
  adapter: Sqlite.Ecto2,
  database: "rephink.sqlite3"

config :rephink, RephinkWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "niENFexfh3crwGnOVw3SU0wniK641P6DkcCevv4b8Z5DHA+Sgs76jHrkeIvQXBj7",
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
