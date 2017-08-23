defmodule RephinkWeb.Router do
  use RephinkWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RephinkWeb do
    pipe_through :api
  end
end
