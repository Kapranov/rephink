# Rephink - Phoenix Framework, RethinkDB, Elm, Webpack

> Install Elixir and Phoenix

The installation guide on the Elixir website contains pretty much
everything you need to install it.

Phoenix is a productive, reliable and fast Web application framework
for Elixir language. By this point you should already have both Erlang
and Elixir installed, so you can start reading Phoenix installation guide
from the Phoenix web site section.

I assume you have Elixir and ``mix`` installed, if not, install it.

First we'll install the latest version of the Phoenix plugin for ``mix``

```
mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez
```

> Install RethinkDB

Installing RethinkDB is pretty simple: just follow the instructions for
your particular OS from their installation page.

Once it's done and the RethinkDB server is up and running, go to
``http://localhost:8080`` and make sure you can access the
administrative console (which automatically comes with the RethinkDB
server).

> Create a new Phoenix application

Phoenix comes with a bunch of CLI generators, of which the main is the
one creating a new project. So, generating a new application is fairly
simple: ``mix phx.new rephink``

```
We are all set! Go into your application by running:

  $ cd rephink

Then configure your database in config/dev.exs and run:

  $ mix ecto.create

Start your Phoenix app with:

  $ mix phx.server

You can also run your app inside IEx (Interactive Elixir) as:

  $ iex -S mix phx.server
```

> RethinkDB adapter for Ecto (only for phoenix version 1.3.0).

```
def deps do
  [
    ...
    {:cowboy, "~> 1.0"},
    {:rethinkdb, "~> 0.4.0"},
    {:rethinkdb_ecto, "~> 0.7"},
    {:rethinkdb_changefeed, "~> 0.0.1"}
  ]
end
```

You can also remove ``postgrex`` since we're not going to use it.

Add a couple of lines to ``config/config.exs`` to specify the adapter:

```
# Configures the repo
config :rephink, Rephink.Repo,
  adapter: RethinkDB.Ecto
```

And update the database configuration in the environment config file
(i.e. ``config/dev.exs``, since we're just trying it all out for now):

```
# Configure your database
config :rephink, Rephink.Repo,
  # version 1
  # [port: 28015, host: "localhost", database: "rephink", db: "rephink"]
  # version 2
  adapter: RethinkDB.Ecto,
  database: "rephink",
  db: "rephink",
  hostname: "localhost",
  port: 28015,
  pool_size: 10
```

Notice the presence of both ``database`` and ``db`` keys in that keyword
list. The reason we need them both is that we're going to use this
configuration with two different libraries (``rethinkdb`` and
``rethinkdb-ecto``) and they have different opinions on the right name
for the database key.

> Update Phoenix application

```
mix hex.info
mix deps.clean --all
mix deps.update --all
mix deps.get
mix ecto.create
```

Update npm packages: ``cd rephink/assets``

```
ncu -u
ncu -a
npm install
```

If you got it all right this should create a database called "rephink"
which should show up in the tables section of the RethinkDB admin
console ([http://localhost:8080/](http://localhost:8080/) by default).

> Create the database table and adding a Post resource

Our app is going to be a simple blog app so our first step is to add a
post resource. Fortunately, the Phoenix generators make this very
simple:

```
mix phx.gen.html Posts Post posts title:string content:text
```

Add the resource to your browser scope in ``lib/rephink_web/router.ex``:

```
defmodule RephinkWeb.Router do
  ...
  scope "/", RephinkWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/posts", PostController
  end
  ...
end
```

Edit default options for schema and migration: ``config/config.exs``

```
# Configures schema and migration
config :rephink, :generators,
  migration: true,
  binary_id: true,
  sample_binary_id: "11111111-1111-1111-1111-111111111111"
```

And run migrations: ``mix ecto.migrate``

> Edit file ``lib/rephink/posts/post.ex``

```
defmodule Rephink.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rephink.Posts.Post

  primary_key {:id, :binary_id, autogenerate: false}
  ...
end
```

> Add validations ``lib/rephink/posts/post.ex``

```
defmodule Rephink.Posts.Post do
  ...
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(title content))
    |> validate_required([:title, :content])
    |> validate_length(:title, min: 5, max: 10)
    |> validate_length(:content, max: 140)
    |> unique_constraint(:title)
  end
  ...
end
```

> To start your Phoenix server:

We are all set! Run Phoenix application: ``$ mix phx.server``

You can also run your app inside IEx (Interactive Elixir) as:
``$ iex -S mix phx.server``


Now you can visit [`localhost:4000/posts`](http://localhost:4000/posts) from your browser.

![rephink](/assets/static/images/rethinkdb.png "rephink")

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
  * Why changes in Phoenix 1.3 are so important?: https://medium.com/wemake-services/why-changes-in-phoenix-1-3-are-so-important-2d50c9bdabb9
  * KEYNOTE: Phoenix 1.3: https://www.youtube.com/watch?v=tMO28ar0lW8
  * Phoenix 1.2.x to 1.3.0 Upgrade Instructions: https://gist.github.com/chrismccord/71ab10d433c98b714b75c886eff17357


### Oleg G.Kapranov August 2017
