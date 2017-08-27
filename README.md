> Test-Driven APIs with Phoenix and Elixir

Learn how to use fast feedback provided by TDD to better understand some
of the Phoenix and Elixir components while implementing a feature.

We will start by thinking about what we want from our implementation. If
we simply jump into generators, things will probably work, but we will
have a lot of useless code in our codebase, and no understanding of the
layers. Since we want to create an API, we do not need any HTML views or
stylesheets. That's a good place to start:

```
mix phx.new rephink --no-html --no-brunch
```

We don't need a database right now, but we will create one, since we are
going to use it at a later stage. We'll use Phoenix's default database,
`Sqlite`: `mix ecto.create`

Now everything looks fine. We can start thinking about our first
feature.

**Developing a Feature: Listing Movies**

It's time to start thinking about the feature. We should avoid dealing
with the implementation details as much as possible.

**Adding an API Endpoint**

What do we know so far? We'll return a JSON response, which means that
we need a JSON library. We need `Poison`. Let's start by adding the
following dependencies to `mix.exs`:

```
defp deps do
  [
    {:phoenix, "~> 1.3.0"},
    {:phoenix_pubsub, "~> 1.0"},
    {:phoenix_ecto, "~> 3.2"},
    {:gettext, "~> 0.11"},
    {:cowboy, "~> 1.0"},
    {:sqlite_ecto2, "~> 2.0", only: [:dev, :test]},
    {:faker, "~> 0.8", only: [:dev, :test]},
    {:poison, "~> 2.2"}
  ]
end
```

Next, we'll run `mix deps.get` to get those dependencies.

It's time to create an integration test. Create a
`test/rephink_web/controllers` directory and a file named
`listing_movies_test.exs` inside it.

Listing movies requires a get request for a movies resource. We need a
HTTP GET request to a "/movies" URI to return some content and a 200
status code.

```
defmodule ListingMoviesIntegrationTest do
  use ExUnit.Case, async: true

  test 'listing movies' do
    response = conn(:get, '/movies')
    assert response.status == 200
  end
end
```

Here's how this will work: we'll add this test and run it. After running
the test, we will make changes every time it fails until we've added
just enough code to make it pass. We'll use:
`mix test test/rephink_web/controllers/listing_movies_test.exs` to run the test. The
test returns the following error message:

We need `Plug`. Let's add it to `test/rephink_web/controllers/listing_movies_test.exs`:

```
defmodule ListingMoviesTest do
  use ExUnit.Case, async: true
  use Plug.Test

  test 'listing movies' do
    response = conn(:get, '/movies')
    assert response.status == 200
  end
end
```

When we run it again, we'll get the following output.

The problem here is the single quotes. Elixir provides double quoted
strings. Single quotes are for char lists. Let's fix this:

```
response = conn(:get, "/movies")
```

We don't have a status code because we are creating a connection, but
we're not making a call to an endpoint with it. Let's add one. We'll
need to call a router, connect to it, and get a response:

```
defmodule ListingMoviesIntegrationTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias RephinkWeb.Router

  @opts Router.init([])
  test 'listing movies' do
    # response = conn(:get, "/movies")
    conn = conn(:get, "/movies")
    response = Router.call(conn, @opts)
    assert response.status == 200
  end
end
```

The test fails because we don't have a route. We're making progress.
Let's open `web/router.ex` and add our route:

```
defmodule RephinkWeb.Router do
  use RephinkWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RephinkWeb do
    pipe_through :api

    get "/movies", MovieController, :index
  end
end
```

```
mix phx.routes
```

We'll run the test again even though we know it is going to fail. In
this case, we'll get the following output:

So, we need to create a controller. Let's create a `movie_controller.ex`
file on the `lib/rephink_web/controllers` directory:

```
defmodule RephinkWeb.MovieController do
  use RephinkWeb, :controller

  def index(conn, _params) do
    render conn, movies: []
  end
end
```
Our action needs a view. Creating a `movie_view.ex` under
`lib/rephink_web/views/movie_view.ex` will fix that:

```
defmodule RephinkWeb.MovieView do
  use RephinkWeb, :view

  def render("index.json", %{movies: movies}) do
    movies
  end
end
```

Let's run it again:

```
Compiling 1 file (.ex)
Generated rephink app
.
Finished in 0.05 seconds
1 test, 0 failures
```

Our first test has passed. Let's add an assertion for the body to make
sure we are on the right path: `assert response.resp_body == "[]"`

The test passes. Now, let's try to consume our resource from bash, run
the server with `mix phx.server`, and use curl to retrieve the movies:

```
curl localhost:4000/movies
```

**Adding a Model**

It works — our empty list is being returned. Now, we need to add a movie
model to persist our movies. Again, we'll use TDD to drive how our model
is going to look. We could read the model straight away, but adding it
to our test first will give us some time to consider what we want it to
look like. Let's give it a name and a rating, and assert its return:

```
defmodule ListingMoviesTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias RephinkWeb.Router

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  @opts Router.init([])
  test 'listing movies' do
    %Movie{name: "Back to the future", rating: 5} |> Repo.insert!

    conn = conn(:get, "/movies")
    response = Router.call(conn, @opts)

    assert response.status == 200
    assert response.resp_body == movies
  end
end
```

Structure does not exist yet. Let's create it using the generator:

```
mix phx.gen.schema Movie movies name rating:integer
```

Now, migrate and take a look at `test/rephink/movie/movie_test.exs`
the generator created for us:

```
defmodule Rephink.MovieTest do
  use Rephink.DataCase

  alias Rephink.Movie

  @valid_attrs %{name: "some content", rating: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Movie.changeset(%Movie{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Movie.changeset(%Movie{}, @invalid_attrs)
    refute changeset.valid?
  end
end
```

Let's run this test: `mix test test/rephink/movie/movie_test.exs`

When we run the integration test again, we'll get the following error:

We've created our structure, but we haven't added it to our test. Let's
add it: `alias Rephink.Movie`

Let's run the test again:

The structure is here, but we can't insert it without using:
`alias Rephink.Repo`.

There are still some things left to fix. First of all, we are returning
a string, and we should be returning a list of movies. Let's fix that in
`lib/rephink_web/controllers/movie_controller.exs`:

```
defmodule RephinkWeb.MovieController do
  use RephinkWeb, :controller
  alias Rephink.Movie
  alias Rephink.Repo

  def index(conn, _params) do
    #  render conn, movies: []
    movies = Repo.all(Movie)
    render conn, movies: movies
  end
end
```

This means that we are trying to encode metadata for the client, and
Poison won't allow us to dothis by default. We can solve this by
implementing `Poison.Encoder` in our model.

```
defmodule Rephink.Movie do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rephink.Movie

  schema "movies" do
    field :name, :string
    field :rating, :integer

    timestamps()
  end

  @doc false
  def changeset(%Movie{} = movie, attrs) do
    movie
    |> cast(attrs, [:name, :rating])
    |> validate_required([:name, :rating])
    |> unique_constraint(:name)
  end

  defimpl Poison.Encoder, for: Movie do
    def encode(movie, _options) do
      movie
      |> Map.from_struct
      |> Map.drop([:__meta__, :__struct__])
      |> Poison.encode!
    end
  end
end
```

Let's run the test again:

Notice we get a JSON response, but it fails. Our expectation is not
encoded. Let's encode the model we've just created in our integration
test:

```
|> Repo.insert!
|> Poison.encode!
```

The output now looks as follows errors:

We're comparing a list with a single movie. Let's fix that:

```
defmodule ListingMoviesTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias RephinkWeb.Router
  alias Rephink.Movie
  alias Rephink.Repo

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  @opts Router.init([])
  test 'listing movies' do
    %Movie{name: "Back to the future", rating: 5} |> Repo.insert!
    movies = Repo.all(Movie)
      |> Poison.encode!

    conn = conn(:get, "/movies")
    response = Router.call(conn, @opts)

    assert response.status == 200
    assert response.resp_body == movies
  end
end
```

Let's try using it with Curl: `curl localhost:4000/movies`

Our resource is done. Let's run all of our specs to make sure everything
is working before going further: `mix test`.

When we run the test again, everything should be working properly.

**Conclusion**

When writing code, we need to have confidence in what we do, and TDD is
a powerful tool for this. The feedback it gives us can make things
clearer when we're not sure how to implement a feature. The faster this
feedback loop is, the faster we'll move forward, even with new
technologies.

### 2017 August Oleg G.Kapranov
