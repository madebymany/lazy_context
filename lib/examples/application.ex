defmodule LazyContent.Examples.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(LazyContext.Examples.Repo, []),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Adapt.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # # Tell Phoenix to update the endpoint configuration
  # # whenever the application is updated.
  # def config_change(changed, _new, removed) do
  #   AdaptWeb.Endpoint.config_change(changed, removed)
  #   :ok
  # end
end
