defmodule RephinkWeb.Router do
  use RephinkWeb, :router

  pipeline :api do
    plug :accepts, [:v1, :v2, :v3]
    plug RephinkWeb.Version
  end

  scope "/", RephinkWeb do
    pipe_through :api
    resources "/todos", TodoController, only: [:show]
  end
end
