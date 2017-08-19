defmodule RephinkWeb.Router do
  use RephinkWeb, :router

  pipeline :v1 do
    plug :accepts, ["json"]
    plug RephinkWeb.Version, version: :v1
  end

  pipeline :v2 do
    plug :accepts, ["json"]
    plug RephinkWeb.Version, version: :v2
  end

  pipeline :v3 do
    plug :accepts, ["json"]
    plug RephinkWeb.Version, version: :v3
  end

  scope "/v1", RephinkWeb do
    pipe_through :v1
    resources "/todos", TodoController, only: [:show]
  end

  scope "/v2", RephinkWeb do
    pipe_through :v2
    resources "/todos", TodoController, only: [:show]
  end

  scope "/v3", RephinkWeb do
    pipe_through :v3
    resources "/todos", TodoController, only: [:show]
  end
end
