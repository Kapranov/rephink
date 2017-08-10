defmodule RethinkTest.Database do
  def init(db) do
    case RethinkDB.Connection.start_link([db: db]) do
      {:ok, conn} ->
        conn
      _ ->
        :error
    end
  end

  def run(q, conn) do
    RethinkDB.run(q, conn)
  end

  def stop(pid) do
    RethinkDB.Connection.stop(pid)
  end
end
