defmodule CompPS.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CompPSWeb.Telemetry,
      CompPS.Repo,
      {DNSCluster, query: Application.get_env(:component_pub_sub, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: CompPS.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: CompPS.Finch},
      # Start a worker by calling: CompPS.Worker.start_link(arg)
      # {CompPS.Worker, arg},
      # Start to serve requests, typically the last entry
      CompPSWeb.Endpoint,
      CompPS.Counter
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CompPS.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CompPSWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
