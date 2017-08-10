defmodule Rephink do
  @moduledoc """
  Documentation for Rephink.
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

  @doc """
  Connecting to RethinkDB
  """
  def start(_type, _args) do
    import Supervisor.Spec
    children = [
      worker(Rephink.Connection, [[ host: "localhost", port: 28015, db: "compose"]])
    ]
    Supervisor.start_link(children, strategy: :one_for_one, name: Rephink.Supervisor)
  end
end

defmodule Rephink.Connection do
  use RethinkDB.Connection
end
