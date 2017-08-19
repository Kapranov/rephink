defmodule RephinkWeb.Router do
  use RephinkWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug RephinkWeb.Version, %{"v1" => :v1, "v2" => :v2, "v3" => :v3}
  end

  scope "/", RephinkWeb do
    pipe_through :api
    resources "/todos", TodoController, only: [:show]
  end
end
