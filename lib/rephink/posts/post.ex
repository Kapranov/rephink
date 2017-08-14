defmodule Rephink.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(title content))
    |> validate_required([:title, :content])
    |> validate_length(:title, min: 5, max: 10)
    |> validate_length(:content, max: 140)
    |> unique_constraint(:title)
  end
end
