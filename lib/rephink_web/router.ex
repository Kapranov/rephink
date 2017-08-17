defmodule RephinkWeb.Router do
  use RephinkWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RephinkWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", RephinkWeb do
    pipe_through :api

    resources "/posts", PostController, only: [:index]
  end
end
