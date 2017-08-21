defmodule RephinkWeb.TodoController do
  use RephinkWeb, :controller
  alias Rephink.Todos.Todo

  def show(%{assigns: %{version: :v1}}=conn, _params) do
    todo = Todo.build(:v1)
    render conn, "show.v1.json", todo: todo
  end

  def show(%{assigns: %{version: :v2}}=conn, _params) do
    todo = Todo.build(:v2)
    render conn, "show.v2.json", todo: todo
  end

  def show(%{assigns: %{version: :v3}}=conn, _params) do
    todo = Todo.build(:v3)
    render conn, "show.v3.json", todo: todo
  end
end
