defmodule RephinkWeb.MovieController do
  use RephinkWeb, :controller

  def index(conn, _params) do
    render conn, movies: []
  end
end
