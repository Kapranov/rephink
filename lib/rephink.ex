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

  # version 1
  #def call(conn, opts) do
  #  # And we send a response back, with a status code and a body
  #  send_resp(conn, 200, "#{opts[:my_option]}, World!")
  #end

  # version 2
  def call(%Plug.Conn{request_path: "/" <> name} = conn, opts) do
    send_resp(conn, 200, "Hello, #{name}")
  end

  @moduledoc """
  Documentation for Rephink
  """

  @doc """
  Hello world.

  ## Examples

      iex> Rephink.hello
      :world

  """
  def hello do
    :world
  end
end
