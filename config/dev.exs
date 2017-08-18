use Mix.Config

config :rephink, RephinkWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :rephink, RephinkWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/rephink_web/views/.*(ex)$},
      ~r{lib/rephink_web/templates/.*(eex)$}
    ]
  ]

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :rephink, Rephink.Repo,
  adapter: Sqlite.Ecto2,
  database: System.get_env("DB_DEV")
