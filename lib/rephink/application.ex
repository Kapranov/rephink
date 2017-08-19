defmodule Rephink.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(RephinkWeb.Endpoint, []),
    ]

    opts = [strategy: :one_for_one, name: Rephink.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    RephinkWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
