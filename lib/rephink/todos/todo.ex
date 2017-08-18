defmodule Rephink.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rephink.Todos.Todo


  schema "todos" do
    field :completed, :boolean, default: false
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(%Todo{} = todo, attrs) do
    todo
    |> cast(attrs, [:title, :completed])
    |> validate_required([:title, :completed])
  end
end
