defmodule RephinkWeb.TodoView do
  use RephinkWeb, :view

  def render("show.v1.json", %{todo: todo}) do
    %{
      id: todo.id,
      completed: todo.completed,
      title: Enum.at(todo.titles, 0)
    }
  end

  def render("show.v2.json", %{todo: todo}) do
    %{
      id: todo.id,
      completed: todo.completed,
      titles: todo.titles
    }
  end

  def render("show.v3.json", %{todo: todo}) do
    %{
      id: todo.id,
      completed: todo.completed,
      titles: todo.titles
    }
  end

end
