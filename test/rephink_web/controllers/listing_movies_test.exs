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
