defmodule Rephink.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rephink.Posts.Post

  schema "posts" do
    field :content, :string
    field :title, :string

    timestamps()
  end

  @doc false
  #def changeset(%Post{} = post, attrs) do
  #  post
  #  |> cast(attrs, [:title, :content])
  #  |> validate_required([:title, :content])
  #end
  def changeset(struct, params \\ %{}) do
    struct
    #|> cast(params, [:title, :content])
    |> cast(params, ~w(title content))
    |> validate_required([:title, :content])
    |> validate_length(:title, min: 5, max: 10)
    |> validate_length(:content, max: 140)
    |> unique_constraint(:title)
  end
end
