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
