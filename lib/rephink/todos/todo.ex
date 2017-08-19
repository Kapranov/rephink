defmodule Rephink.Todos.Todo do
  defstruct id: nil, titles: nil, completed: nil

  def build(:v1), do: _build(["MY Task #1"])
  def build(:v2), do: _build(["MY Task #2", "Hello, Welcome!"])
  def build(:v3), do: _build(["MY Task #3", "How are your there!"])

  defp _build(titles) do
    %__MODULE__{
      id: 1,
      completed: true,
      titles: titles
    }
  end
end
