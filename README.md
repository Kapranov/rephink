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

It's time to create an integration test. Create a `test/integration`
directory and a file named `listing_movies_test.exs` inside it.

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
`mix test test/integration/listing_movies_test.exs` to run the test. The
test returns the following error message:

```
** (CompileError) test/integration/listing_movies_test.exs:5: undefined function conn/2
```

We need `Plug`. Let's add it to `test/integration/listing_movies_test.exs`:

```
defmodule ListingMoviesIntegrationTest do
  use ExUnit.Case, async: true
  use Plug.Test

  test 'listing movies' do
    response = conn(:get, '/movies')
    assert response.status == 200
  end
end
```

When we run it again, we'll get the following output:

```
1) test listing movies (ListingMoviesIntegrationTest)
   test/integration/listing_movies_test.exs:5
   ** (FunctionClauseError) no function clause matching in URI.parse/1

   The following arguments were given to URI.parse/1:

      # 1
      '/movies'

   code: response = conn(:get, '/movies')
   ...
```

The problem here is the single quotes. Elixir provides double quoted
strings. Single quotes are for char lists. Let's fix this:

```
response = conn(:get, "/movies")
```

```
1) test listing movies (ListingMoviesIntegrationTest)
   test/integration/listing_movies_test.exs:5
   Assertion with == failed
   code:  assert response.status() == 200
   ...
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

```
1) test listing movies (ListingMoviesIntegrationTest)
   test/integration/listing_movies_test.exs:7
   ** (Phoenix.Router.NoRouteError) no route found for GET /movies (RephinkWeb.Router)
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

```
1) test listing movies (ListingMoviesIntegrationTest)
   test/integration/listing_movies_test.exs:7
   ** (Plug.Conn.WrapperError) ** (UndefinedFunctionError) function
     RephinkWeb.MovieController.init/1 is undefined
   ...
```

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

```
1) test listing movies (ListingMoviesIntegrationTest)
   test/integration/listing_movies_test.exs:7
   ** (Plug.Conn.WrapperError) ** (UndefinedFunctionError) function
     RephinkWeb.MovieView.render/2
   ...
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
### 2017 August Oleg G.Kapranov
