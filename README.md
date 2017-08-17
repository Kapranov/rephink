# Phoenix REST APIs

```
mix phx.gen.json Todos Todo todos title:string completed:boolean

mkdir lib/rephink_web/controllers/v1 
mv lib/rephink_web/controllers/todo_controller.ex lib/rephink_web/controllers/v1/

mkdir lib/rephink_web/views/v1
mv lib/rephink_web/views/todo_view.ex lib/rephink_web/views/v1/

mkdir test/rephink_web/controllers/v1
mv test/rephink_web/controllers/todo_controller_test.exs test/rephink_web/controllers/v1/

# rename module: lib/rephink_web/controllers/v1/todo_controller.ex
defmodule RephinkWeb.V1.TodoController do
  ...
end

# rename module: test/rephink_web/controllers/v1/todo_controller_test.e
defmodule RephinkWeb.V1.TodoControllerTest do
  ...
end

# rename module: lib/rephink_web/views/v1/todo_view.ex
defmodule RephinkWeb.V1.TodoView do
  ...
end

# fix todo_path on v1_todo_path: lib/rephink_web/controllers/v1/todo_controller.ex
|> put_resp_header("location", v1_todo_path(conn, :show, todo))

mix phx.routes

v1_todo_path  GET     /v1/todos           RephinkWeb.V1.TodoController :index
v1_todo_path  GET     /v1/todos/:id/edit  RephinkWeb.V1.TodoController :edit
v1_todo_path  GET     /v1/todos/new       RephinkWeb.V1.TodoController :new
v1_todo_path  GET     /v1/todos/:id       RephinkWeb.V1.TodoController :show
v1_todo_path  POST    /v1/todos           RephinkWeb.V1.TodoController :create
v1_todo_path  PATCH   /v1/todos/:id       RephinkWeb.V1.TodoController :update
              PUT     /v1/todos/:id       RephinkWeb.V1.TodoController :update
v1_todo_path  DELETE  /v1/todos/:id       RephinkWeb.V1.TodoController :delete
```



To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

### 2017 August Oleg G.Kapranov
