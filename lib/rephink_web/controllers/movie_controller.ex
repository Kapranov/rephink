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
