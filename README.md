# Rephink

**Connecting to RethinkDB with Elixir**

> Preparation

```
mix new rephink
cd rephink
make test
```

Now we need to add in the rethinkdb library in ``mix.exs``:

```
defp deps do
  [
    {:rethinkdb, "~> 0.4.0"}
  ]
end
```

With that in place, we can run:

```
mix deps.get
mix.deps.update --all
iex -S mix
```

Now we can import the RethinkDB library with ``import RethinkDB``:

```
import RethinkDB

{ :ok, conn } = RethinkDB.Connection.start_link([host:"localhost",db:"compose"])

results=RethinkDB.Query.table("agents") |> RethinkDB.run(conn)

import RethinkDB.Query

results=table("agents") |> eq_join("org_id",table("orgs")) |> zip() |> run(conn)
```

With the namespace clutter gone, we can query, ``eq_join`` and ``zip``
together two tables with ease. Note we also just used ``run(conn)`` to
execute the query.

First stop is to add a supervised connection from Elixir's OTP to
RethinkDB. The OTP, Open Telecom Platform, is a group of libraries that
ship with Elixir and offer a framework and tools for managing the
fault-tolerant, robust applications that are the trademark of the Erlang
family.

We could get by with using the commands we used above to make queries,
but that's not the Elixir (or Erlang) way. For practical applications,
the OTP platform has the concepts of supervisors and workers and managed
startups. So as part of a managed startup, we're going to create a
supervisor which has one worker whose task is to manage a connection to
RethinkDB. You can read more about the supervisor and worker concept in
the [Elixir documentation][1].

So, let's edit ``lib/rephink.ex`` so it looks like this:

```
defmodule Rephink do
  @doc """
  Connecting to RethinkDB
  """
  def start(_type, _args) do
    import Supervisor.Spec
    children = [
      worker(Rephink.Connection, [[ host: "localhost", port: 28015, db: "compose"]])
    ]
    Supervisor.start_link(children, strategy: :one_for_one, name: Rephink.Supervisor)
  end
end

defmodule Rephink.Connection do
  use RethinkDB.Connection
end
```

This defines the startup for our application. It creates children for a
supervisor, of which there's only one, a worker, named
``Rephink.Connection``. That worker will be presented with one argument
when invoked, a list of options which should be familiar as they are the
options we used to create a connection interactively. With the children
defined, the ``start_link`` function is called for Supervisor, which
will, in turn, invoke ``start_link`` on all the children. And how does
that connect up with the RethinkDB libraries? The last module definition
defines ``Rephink.Connection`` as using ``Rephink.Connection" to make
that link.

To make that code run at startup, we need to modify the ``mix.exs`` file
this time changing the application definition from this:

```
def application do
  [
    extra_applications: [:logger],
    mod: {Rephink, []}
  ]
end
```

This will now wake up our connection at startup. Now we can make a
module that uses the database connection. Create ``lib/database.ex``
and add this to it:

```
defmodule Database do
  import RethinkDB.Query, only: [table_create: 1, table: 1, insert: 2]

  def create_table(table_name) do
    table_create(table_name) |> Rephink.Connection.run
  end

  def create_entry(table_name, entry) do
    table(table_name) |> insert(%{title: entry}) |> Rephink.Connection.run
  end
end
```

The module imports specific parts of RethinkDB.Query which it then uses
to form a "create table" function and a "create entry" function. Note
how it refers to the ``Rephink.Connection" to run the queries.

With this in place, we can test things out in the interactive shell,
running ``iex -S mix``.

The connection to RethinkDB is already up and running and we can invoke
the Database module to create a table and add an entry:

```
Database.create_table("posts")
Database.create_entry("posts","Hello, Application!")
```

And that connection is available for our own ad-hoc queries too:

```
import RethinkDB
import RethinkDB.Query

table("posts") |> run(Elxrdb.Connection)
```

The RethinkDB Elixir driver is an idiomatic implementation of ReQLs
format which makes it fairly simple to translate ReQL command chains
from other languages to Elixir piping. Elixir's interactive shell also
makes it easy to explore the driver, and RethinkDBs capabilities.

### 10 Aug 2017 Oleg G.Kapranov

[1]: https://elixir-lang.org/getting-started/mix-otp/supervisor-and-application.html
