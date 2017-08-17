# Phoenix REST APIs ToDo Application

```
mix phx.new rephink --no-brunch

# add sqlite_ecto2
defp deps do
  [
    {:phoenix, "~> 1.3.0"},
    {:phoenix_pubsub, "~> 1.0"},
    {:phoenix_ecto, "~> 3.2"},
    {:phoenix_html, "~> 2.10"},
    {:phoenix_live_reload, "~> 1.0", only: :dev},
    {:gettext, "~> 0.11"},
    {:cowboy, "~> 1.0"},
    {:sqlite_ecto2, "~> 2.0"},
    {:faker, "~> 0.8", only: [:dev, :test]}
  ]
end

# edit config/config.exs, config/dev.exs, config/prod.exs, config/, prod.secret.exs, config/test.exs

# edit lib/rephink/repo.ex
defmodule Rephink.Repo do
  use Ecto.Repo, otp_app: :rephink, adapter: Application.get_env(:rephink, :ecto_adapter)
  ...
end

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

# fix todo_path on v1_todo_path: test/rephink_web/controllers/v1/todo_controller_test.exs
# fix alias RephinkWeb.TodoView: lib/rephink_web/views/v1/todo_view.ex
alias RephinkWeb.V1.TodoView


mix test

.................

Finished in 0.3 seconds
17 tests, 0 failures

Randomized with seed 928443

# run migration
mix ecto.migrate

# run application
mix phx.server

# create first todo
curl -H "Content-Type: application/json" -X POST -d '{"todo":{"title":"Buy a Wii U","completed":true}}' http://localhost:4000/v1/todos
#=> {"data":{"title":"Buy a Wii U","id":1,"completed":true}}

# create second todo
curl -H "Content-Type: application/json" -X POST -d '{"todo":{"title":"Get A+","completed":false}}' http://localhost:4000/v1/todos
#=> {"data":{"title":"Get A+","id":2,"completed":false}}

# get all todos
curl -H "Content-Type: application/json" http://localhost:4000/v1/todos
#=> {"data":[{"title":"Buy a Wii U","id":1,"completed":true},{"title":"Get A+","id":2,"completed":false}]}

# get #2 todo
curl -H "Content-Type: application/json" http://localhost:4000/v1/todos/2
#=> {"data":{"title":"Get A+","id":2,"completed":false}}
```

### 2017 August Oleg G.Kapranov
