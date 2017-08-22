defmodule MyPipeline do
  use Plug.Builder

  plug Plug.Logger
  plug :extract_name
  plug :greet, %{my_option: "Hello, MyPipeline Plug Bulder!"}

  def extract_name(%Plug.Conn{request_path: "/" <> name} = conn, opts) do
    assign(conn, :name, name)
  end

  def greet(conn, opts) do
    conn
    |> send_resp(200, "#{opts[:my_option]}, #{conn.assigns.name}")
  end
end
