defmodule RephinkWeb.Version do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    assign(conn, :version, opts[:version])
  end
end
