defmodule RephinkWeb.TodoControllerTest do
  use RephinkWeb.ConnCase

  alias Rephink.Todos.Todo

  test "GET /v1/todos/1", %{conn: conn} do
    todo = Todo.build(:v1)
    conn = get(conn, "/v1/todos/1")
    response = json_response(conn, 200)

    assert response["id"] == todo.id
    assert response["completed"] == todo.completed
    assert response["titles"] == Enum.at(todo.titles, 1)
  end

  test "GET /v2/todos/1", %{conn: conn} do
    todo = Todo.build(:v2)
    conn = get(conn, "/v2/todos/1")
    response = json_response(conn, 200)

    assert response["id"] == todo.id
    assert response["completed"] == todo.completed
    assert response["titles"] == todo.titles
  end

  test "GET /v3/todos/1", %{conn: conn} do
    todo = Todo.build(:v3)
    conn = get(conn, "/v3/todos/1")
    response = json_response(conn, 200)

    assert response["id"] == todo.id
    assert response["completed"] == todo.completed
    assert response["titles"] == Enum.at(todo.titles, 2)
  end
end
