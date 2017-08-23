defmodule RephinkWeb.MovieView do
  use RephinkWeb, :view

  def render("index.json", %{movies: movies}) do
    movies
  end
end
