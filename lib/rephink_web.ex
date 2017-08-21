defmodule RephinkWeb do
  def controller do
    quote do
      use Phoenix.Controller, namespace: RephinkWeb
      import RephinkWeb.Router.Helpers
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/rephink_web/templates",
                        namespace: RephinkWeb

      import RephinkWeb.Router.Helpers
      import RephinkWeb.ErrorHelpers
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
