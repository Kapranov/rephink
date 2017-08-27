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
