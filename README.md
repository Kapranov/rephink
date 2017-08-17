# Phoenix Framework – Webpack  and deploy Distillery

```bash
mix phx.new rephink --no-brunch
cd rephink

# add some packages
def included_applications do
  [:sqlitex, :sbroker]
end

defp deps do
  [
    {:phoenix, "~> 1.3.0"},
    {:phoenix_pubsub, "~> 1.0"},
    {:phoenix_ecto, "~> 3.2"},
    {:phoenix_html, "~> 2.10"},
    {:phoenix_live_reload, "~> 1.0", only: :dev},
    {:gettext, "~> 0.11"},
    {:cowboy, "~> 1.0"},
    {:sqlite_ecto2, "~> 2.0", only: [:dev, :prod, :test]},
    {:ex_machina, "~> 2.0", only: [:dev, :test]},
    {:faker, "~> 0.8", only: [:dev, :test]},
    {:poolboy, "~> 1.5"},
    {:distillery, "~> 1.4"},
    {:sqlitex, "~> 1.3"},
    {:sbroker, "~> 1.0"}
  ]
end

# edit config/config.exs
config :rephink, Rephink.Repo,
  adapter: Sqlite.Ecto2,
  database: "rephink.sqlite3"

config :rephink, :generators,
  migration: true,
  binary_id: false,
  sample_binary_id: "11111111-1111-1111-1111-111111111111"

# edit config/dev.exs
config :rephink, RephinkWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [npm: ["run", "watch"]]

config :rephink, Rephink.Repo,
  adapter: Sqlite.Ecto2,
  database: "rephink.sqlite3"

# edit config/prod.exs
config :rephink, RephinkWeb.Endpoint,
  load_from_system_env: true,
  http: [port: {:system, "PORT"}],
  url: [host: "localhost", port: {:system, "PORT"}],
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  root: "."

# edit config/prod.secret.exs
config :rephink, Rephink.Repo,
  adapter: Sqlite.Ecto2,
  database: "rephink.sqlite3"

# edit config/test.exs
config :rephink, :ecto_adapter, Sqlite.Ecto2

config :rephink, Rephink.Repo,
  adapter: Application.get_env(:rephink, :ecto_adapter),
  database: "test/rephink_test.sqlite3",
  pool: Ecto.Adapters.SQL.Sandbox,
  size: 1,
  max_overflow: 0

# edit lib/rephink/repo.ex
defmodule Rephink.Repo do
  use Ecto.Repo, otp_app: :rephink, adapter: Application.get_env(:rephink, :ecto_adapter)
  ...
end

# edit .gitignore
/_build
/db
/deps
/*.ez
/npm_modules/*
/priv/static/*
erl_crash.dump
# /config/*.secret.exs


# run commands
mix deps.clean --all
rm -f mix.lock
rm -fr /_build
mix deps.get
mix deps.update --all
mix deps.get

mix ecto.create
mix ecto.migrate

mix test

mix phx.gen.json Posts Post posts title:string content:text
# only generates an Ecto schema and migration.
# mix phx.gen.schema Post posts title:string content:text

# edit lib/rephink_web/router.ex
...
scope "/api", RephinkWeb do
  pipe_through :api
  resources "/posts", PostController, only: [:index]
end
...

# run check out routes
mix phx.routes

# run migration
mix ecto.migrate

# edit lib/rephink/posts/post.ex
defmodule Rephink.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(title content))
    |> validate_required([:title, :content])
    |> validate_length(:title, min: 5, max: 10)
    |> validate_length(:content, max: 140)
    |> unique_constraint(:title)
  end
end

# add seeds priv/repo/seeds.exs
alias Rephink.Repo
alias Rephink.Posts.Post

for _ <- 1..15 do
  Repo.insert!(%Post{
    title: Faker.Lorem.word,
    content: Faker.Lorem.sentence
  })
end

# run seed
mix run priv/repo/seeds.exs

# run seed for test env
MIX_ENV=test mix ecto.migrate
MIX_ENV=test mix run priv/repo/seeds.exs

# edit controller lib/rephink_web/controllers/post_controller.ex
defmodule RephinkWeb.PostController do
  use RephinkWeb, :controller

  alias Rephink.Posts.Post
  alias Rephink.Repo

  def index(conn, _params) do
    posts = Repo.all(Post)
    render(conn, "posts.json", posts: posts)
  end
end

# edit lib/rephink_web/endpoint.ex
  plug Plug.Static,
    at: "/", from: :rephink, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt cache_manifest.json)

# edit lib/rephink_web/views/layout_view.ex
defmodule RephinkWeb.LayoutView do
  use RephinkWeb, :view

  def digest do
    manifest =
      Application.get_env(:rephink, Rephink.Endpoint, %{})[:cache_static_manifest]
      || "priv/static/cache_manifest.json"

    manifest_file = Application.app_dir(:rephink, manifest)

    if File.exists?(manifest_file) do
      manifest_file
      |> File.read!
    else
      %{}
    end
  end
end

# edit lib/rephink_web/views/post_view.ex
defmodule RephinkWeb.PostView do
  use RephinkWeb, :view
  # alias RephinkWeb.PostView

  def render("posts.json", %{posts: posts}) do
    %{
      posts: Enum.map(posts, &post_json/1)
    }
  end

  def post_json(post) do
    %{
      title: post.title,
      content: post.content
    }
  end
end

# install npm
npm init
npm install --save-dev webpack
npm install --save-dev copy-webpack-plugin
npm install --save-dev babel-loader babel-core babel-preset-es2015
mix deps.get
mix phx.digest
mix release.init

# edit rel/config.exs
Path.join(["rel", "rel/hooks", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    default_release: :default,
    default_environment: Mix.env()

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"8N(h?7UMEIZC20:quhQy2$DJZtrul~[_jq:_j(qSRh30{D/eN8VuU](GM=H6%LqK"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"vX{MSt4RAK|1I;&zLoc1ZR**mSvF6}jTzTTxqWwU)tkx4)[7^X%oK((Z{)Tl:kN&"
  # new features
  set pre_start_hook: "rel/hooks/pre_start"
  set post_start_hook: "rel/hooks/post_start"
end

release :rephink do
  set version: current_version(:rephink)
  set applications: [
    :runtime_tools
  ]
end

# create dirs and files
mkdir rel/hooks
touch rel/hooks/post_start
touch rel/hooks/pre_start

# edit rel/hooks/post_start
set +e

while true; do
  nodetool ping
  EXIT_CODE=$?
  if [ $EXIT_CODE -eq 0 ]; then
    echo "[Post-start] Application is up!"
    break
  fi
done

set -e

# edit rel/hooks/pre_start
echo "[Pre-start] Starting Rephink"

# edit package.json
"scripts": {
  "test": "echo \"Error: no test specified\" && exit 1",
  "watch": "webpack --watch-stdin --progress --color",
  "deploy": "webpack -p"
},

# edit webpack.config.js
var CopyWebpackPlugin = require("copy-webpack-plugin");

module.exports = {
  entry: __dirname + "/lib/rephink_web/js/app.js",
  output: {
    path: __dirname + "/priv/static",
    filename: "js/app.js"
  },
  plugins: [
    new CopyWebpackPlugin([{ from: __dirname + "/lib/rephink_web/static" }])
  ],
  module: {
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: "babel-loader",
        query: {
          presets: ["es2015"]
        }
      }
    ]
  }
};

# edit lib/rephink_web/js/app.js
mkdir lib/rephink_web/js
touch lib/rephink_web/js/app.js
touch lib/rephink_web/js/rephink.js

# lib/rephink_web/js/app.js
import load from './rephink';

load();

# lib/rephink_web/js/rephink.js
export default function load() {
  let xhttp = new XMLHttpRequest();

  xhttp.onreadystatechange = function() {
    if (this.readyState === 4 && this.status === 200) {
      let data = JSON.parse(this.responseText);

      render(data.posts);
    }
  };

  xhttp.open("GET", "/api/posts", true);
  xhttp.send();
}

function render(posts) {
  let items = posts.reduce(function(acc, post) {
    let li = !posts.content? '<li class="blocked">' : '<li>';
    return acc + li + post.title + '</li>';
  }, "");

  let container = document.getElementById('post-container');
  container.innerHTML = '<ul>' + items + '</ul>';
}

console.log("App js loaded.");

# create dirs and files
mkdir lib/rephink_web/static
mkdir lib/rephink_web/static/css/
mkdir lib/rephink_web/static/images/
touch lib/rephink_web/static/css/post.css
cp priv/static/images/phoenix.png lib/rephink_web/static/images/logo.png
cp priv/static/robots.txt lib/rephink_web/static/
cp priv/static/favicon.ico lib/rephink_web/static/
rm -fr priv/static/*

# edit lib/rephink_web/static/css/post.css
.blocked {
  background: #ffa07a;
}

# edit lib/rephink_web/templates/page/index.html.eex
<div id="post-container"></div>

# edit lib/rephink_web/templates/layout/app.html.eex
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Hello Rephink!</title>
    <link rel="stylesheet" href="<%= static_path(@conn, "/css/post.css") %>">
    <script>
      var digest = <%= raw digest() %>
    </script>
  </head>

  <body>
    <img src="<%= static_path(@conn, "/images/logo.png") %>">

    <%= render @view_module, @view_template, assigns %>
    <script src="<%= static_path(@conn, "/js/app.js") %>"></script>
  </body>
</html>

# check out developmen env

# run command for digest
mix deps.get
npm install

mix phx.server

# check out brouser url
http://localhost:4000
http://localhost:4000/api/posts

# create file lib/rephink/release_tasks.ex
defmodule Release.Tasks do
  alias Rephink.Repo

  def migrate do
    Application.load(:rephink)
    {:ok, _} = Application.ensure_all_started(:ecto)
    {:ok, _} = Repo.__adapter__.ensure_all_started(Repo, :temporary)
    {:ok, _} = Repo.start_link(pool_size: 1)

    path = Application.app_dir(:rephink, "priv/repo/migrations")

    Ecto.Migrator.run(Repo, path, :up, all: true)

    :init.stop()
  end
end

# setup for prod Distillery
npm run deploy
MIX_ENV=prod mix phx.digest
MIX_ENV=prod mix release

# migration db for production
_build/prod/rel/rephink/bin/rephink command 'Elixir.Release.Tasks' migrate

# Release successfully built!
# You can run it in one of the following ways:
#
# Interactive:
PORT=8080 _build/prod/rel/rephink/bin/rephink console
# Foreground:
PORT=8080 _build/prod/rel/rephink/bin/rephink foreground
# Daemon:
PORT=8080 _build/prod/rel/rephink/bin/rephink start

# Simple Production Run
PORT=8080 MIX_ENV=prod mix phx.server
```

> Linux systemd ``init-scripts``

Our application is define dir on ``/opt/rephink/`` and run it from user
has name ``rephink``, create file ``rethink.service`` and will copy to
dir ``/etc/systemd/system/``:

```bash
# Rephink is a Phoenix, Webpack and Distillery demo application

[Unit]
Description=Rethink application
After=network.target

[Service]
Type=simple
User=rethink
RemainAfterExit=yes
Environment=PORT=8080
WorkingDirectory=/opt/rethink
ExecStart=/opt/rethink/bin/rethink start
ExecStop=/opt/rethink/bin/rethink stop
Restart=on-failure
TimeoutSec=300

[Install]
WantedBy=multi-user.target
```

```bash
$ sudo cp rephink.service /etc/systemd/system

# on autostart:
sudo systemctl enable rethink.service

# run application
sudo systemctl start rethink
```

> Allow non-root process to bind to port 80 and 443:

```bash
setcap 'cap_net_bind_service=+ep' /usr/local/lib/elixir/bin/mix
socat tcp6-listen:80,fork tcp6:8080
```

### 2017 August Oleg G.Kapranov
