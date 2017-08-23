defmodule Rephink do
  # The Plug.Conn module gives us the main functions
  # we will use to work with our connection, which is
  # a %Plug.Conn{} struct, also defined in this module.
  import Plug.Conn

  def init(opts) do
    # Here we just add a new entry in the opts map,
    # that we can use in the call/2 function
    Map.put(opts, :my_option, "Hello")
  end

  # example 1
  #def call(conn, opts) do
  #  # And we send a response back, with a status code and a body
  #  send_resp(conn, 200, "#{opts[:my_option]}, World!")
  #end

  # example 2
  def call(%Plug.Conn{request_path: "/" <> name} = conn, opts) do
    send_resp(conn, 200, "Hello, #{name}")
  end

  # example 3
  #def init(opts), do: opts
  #
  #def call(conn, _opts) do
  #  body = "Hello, World!"
  #  conn
  #  |> put_resp_content_type("text/plain") # another plug
  #  |> send_resp(200, body)
  #end

  # example 4
  #def call(conn, _opts) do
  #  body = %{body: "Hello, World!"} |> Poison.encode!
  #  conn
  #  |> put_resp_content_type("application/json")      # JSON type
  #  |> send_resp(200, body)                           # send it!
  #end

  # example 5
  #def call(conn, _opts) do
  #  body = conn |> fetch_cookies |> Map.get(:cookies) |> Poison.encode!
  #
  #  conn
  #  |> put_resp_cookie("hello", DateTime.utc_now |> DateTime.to_string)
  #  |> put_resp_content_type("application/json")      # another plug
  #  |> send_resp(200, body)
  #end

  @moduledoc """
  Documentation for Rephink
  """

  @doc """
  Hello world.
  iex> Rephink.hello
  :world
  """
  def hello do
    :world
  end
end
