defmodule RephinkWeb.Router do
  use RephinkWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RephinkWeb do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      resources "/todos", TodoController
    end
  end
end
