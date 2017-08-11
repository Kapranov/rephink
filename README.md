# Phoenix using [Sqlite.Ecto2][1] as a Test Database

Configuring Ecto ``mix_ex``:

```
defp deps do
  [
    {:phoenix, "~> 1.3.0"},
    {:phoenix_pubsub, "~> 1.0"},
    {:phoenix_ecto, "~> 3.2"},
    {:phoenix_html, "~> 2.10"},
    {:phoenix_live_reload, "~> 1.0", only: :dev},
    {:gettext, "~> 0.11"},
    {:cowboy, "~> 1.0"},
    {:sqlite_ecto2, "~> 2.0", only: [:dev, :test]},
    {:ex_machina, "~> 2.0", only: [:dev, :test]},
    {:faker, "~> 0.8", only: [:dev, :test]},
    {:poolboy, "~> 1.5"}
  ]
end
```

Edit the ``config/config.exs``:

```
config :rephink, Rephink.Repo,
  adapter: Sqlite.Ecto2,
  database: "rephink.sqlite3"
```

Edit the ``config/dev.exs``:

```
config :rephink, Rephink.Repo,
  adapter: Sqlite.Ecto2,
  database: "rephink.sqlite3",
  size: 1,
  max_overflow: 0
```

Edit the ``config/test.exs``:

```
config :rephink, :ecto_adapter, Sqlite.Ecto2

config :rephink, Rephink.Repo,
  adapter: Application.get_env(:rephink, :ecto_adapter),
  database: "test/rephink_test.sqlite3",
  pool: Ecto.Adapters.SQL.Sandbox,
  size: 1,
  max_overflow: 0
```

Edit the ``Rephink.Repo`` module in ``lib/rephink/repo.ex`` to use
the ``sqlite_ecto2`` adapter:

```
defmodule Rephink.Repo do
  use Ecto.Repo, otp_app: :rephink, adapter: Application.get_env(:rephink, :ecto_adapter)
end
```

Edit file ``test/test_helper.exs``:

```
ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Rephink.Repo, :manual)
```

Edit file ``lib/rephink/posts/post.ex``:

```
defmodule Rephink.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rephink.Posts.Post

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
```

Start up:

```
$ mix deps.clean --all
$ mix deps.get
$ mix deps.update --all
$ mix ecto.create
$ mix ecto.migrate
$ mix run priv/repo/seeds.exs
$ mix test
$ mix phx.server
# or
$ iex -S mix phx.server

$ export MIX_ENV=prod
$ mix ecto.create
$ mix ecto.migrate
$ mix test
```


Let's quickly make sure the [model][2] is working with iex ``iex -S mix``:

```bash
sqlite3 rephink.sqlite3 .schema
CREATE TABLE "schema_migrations" ("version" BIGINT PRIMARY KEY, "inserted_at" DATETIME);
CREATE TABLE "posts" ("id" INTEGER PRIMARY KEY AUTOINCREMENT, "title" STRING, "content" TEXT, "inserted_at" DATETIME NOT NULL, "updated_at" DATETIME NOT NULL);
```

```
import Ecto.Query

query = from w in Rephink.Posts.Post, where: w.title == "sit"
Rephink.Repo.all(query)

Rephink.Repo.delete_all(Rephink.Posts.Post)

Rephink.Repo.all(Rephink.Posts.Post |> select([post], post.title))
Rephink.Repo.insert(%Rephink.Posts.Post{title: "Notice", content: "how it resembles."})
```

> Increasing the amount of inotify watchers for Debian


```bash
cat /proc/sys/fs/inotify/max_user_watches
echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf && sysctl -p
```

### Oleg G.Kapranov August 2017

[1]: https://github.com/scouten/sqlite_ecto2
[2]: https://github.com/scouten/sqlite_ecto2/blob/master/docs/tutorial.md
