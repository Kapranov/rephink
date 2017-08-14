defmodule RephinkWeb.PostController do
  use RephinkWeb, :controller

  alias Rephink.Posts
  alias Rephink.Posts.Post
  alias Rephink.Repo

  def index(conn, _params) do
    posts = Repo.all(Post)
    render(conn, "posts.json", posts: posts)
  end
end
