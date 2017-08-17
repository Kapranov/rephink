defmodule RephinkWeb.PostView do
  use RephinkWeb, :view
  # alias RephinkWeb.PostView

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

  #def render("index.json", %{posts: posts}) do
  #  %{data: render_many(posts, PostView, "post.json")}
  #end

  #def render("show.json", %{post: post}) do
  #  %{data: render_one(post, PostView, "post.json")}
  #end

  #def render("post.json", %{post: post}) do
  #  %{id: post.id,
  #    title: post.title,
  #    content: post.content}
  #end
end
