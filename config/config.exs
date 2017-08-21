use Mix.Config

config :rephink, RephinkWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vgtp/fQm4m40eZKVDb5w14jYfGJ6ovaBjowhWmb9PSKTW1LmBZUr8tM6nesUloyk",
  render_errors: [view: RephinkWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Rephink.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :plug, :mime, %{
  "application/vnd.app.v1+json" => [:v1],
  "application/vnd.app.v2+json" => [:v2],
  "application/vnd.app.v3+json" => [:v3]
}

#config :plug, :mimes, %{
#  "application/vnd.app.v1+json" => [:v1],
#  "application/vnd.app.v2+json" => [:v2]
#}

import_config "#{Mix.env}.exs"
