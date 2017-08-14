defmodule RephinkWeb.PostView do
  use RephinkWeb, :view

  def render("posts.json", %{posts: posts}) do
    %{
      posts: Enum.map(posts, &post_json/1)
    }
  end

  def post_json(post) do
    %{
      title: post.title,
      content: post.content
    }
  end
end
