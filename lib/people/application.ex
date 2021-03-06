defmodule People.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PeopleWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: People.PubSub},
      # Start the Endpoint (http/https)
      PeopleWeb.Endpoint,
      # Cache
      {People.CacheService, name: People.CacheService}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: People.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PeopleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
