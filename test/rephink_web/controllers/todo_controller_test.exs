defmodule RephinkWeb.TodoControllerTest do
  use RephinkWeb.ConnCase

  alias Rephink.Todos.Todo

  setup %{conn: conn}=config do
    conn = put_req_header(conn, "accept", config.accept_header)
    {:ok, conn: conn}
  end

  @tag accept_header: "application/vnd.app.v1+json"
  test "GET /todos/1 with Accept: application/vnd.app.v1+json", %{conn: conn} do
    todo = Todo.build(:v1)
    conn = get(conn, "/todos/1")
    response = json_response(conn, 200)

    assert response["id"] == todo.id
    assert response["completed"] == todo.completed
    #assert response["title"] == Enum.at(todo.titles, 0)
    assert response["titles"] == todo.titles
  end

  #@tag accept_header: "application/vnd.app.v2+json"
  #test "GET /todos/1 with Accept: application/vnd.app.v2+json", %{conn: conn} do
  #  toso = Todo.build(:v2)
  #  conn = get(conn, "/todos/1")
  #  response = json_response(conn, 200)

  #  assert response["id"] == todo.id
  #  assert response["completed"] == todo.completed
  #  assert response["titles"] == todo.titles
  #end

  #@tag accept_header: "application/vnd.app.v3+json"
  #test "GET /todos/1 with Accept: application/vnd.app.v3+json", %{conn: conn} do
  #  todo = Todo.build(:v3)
  #  conn = get(conn, "/todos/1")
  #  response = json_response(conn, 200)

  #  assert response["id"] == todo.id
  #  assert response["completed"] == todo.completed
  #  assert response["title"] == Enum.at(todo.titles, 0)
  #end
end
