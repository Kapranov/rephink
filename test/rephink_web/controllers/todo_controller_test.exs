defmodule RephinkWeb.TodoControllerTest do
  use RephinkWeb.ConnCase

  alias Rephink.Todos.Todo

  test "GET /todos/1 with version param = v1", %{conn: conn} do
    todo = Todo.build(:v1)
    conn = get(conn, "/todos/1", %{"version" => "v1"})
    response = json_response(conn, 200)

    assert response["id"] == todo.id
    assert response["completed"] == todo.completed
    assert response["titles"] == Enum.at(todo.titles, 1)
  end

  test "GET /todos/1 with version param = v2", %{conn: conn} do
    todo = Todo.build(:v2)
    conn = get(conn, "/todos/1", %{"version" => "v2"})
    response = json_response(conn, 200)

    assert response["id"] == todo.id
    assert response["completed"] == todo.completed
    assert response["titles"] == todo.titles
  end

  test "GET /todos/1 with version param = v3", %{conn: conn} do
    todo = Todo.build(:v3)
    conn = get(conn, "/todos/1", %{"version" => "v3"})
    response = json_response(conn, 200)

    assert response["id"] == todo.id
    assert response["completed"] == todo.completed
    assert response["titles"] == Enum.at(todo.titles, 3)
  end
end
