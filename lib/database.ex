defmodule Database do
  import RethinkDB.Query, only: [table_create: 1, table: 1, insert: 2]

  def create_table(table_name) do
    table_create(table_name) |> Rephink.Connection.run
  end

  def create_entry(table_name, entry) do
    table(table_name) |> insert(%{title: entry}) |> Rephink.Connection.run
  end
end
