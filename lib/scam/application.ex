defmodule Scam.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ScamWeb.Telemetry,
      # Start the Ecto repository
      Scam.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Scam.PubSub},
      # Start Finch
      {Finch, name: Scam.Finch},
      # Start the Endpoint (http/https)
      ScamWeb.Endpoint
      # Start a worker by calling: Scam.Worker.start_link(arg)
      # {Scam.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Scam.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ScamWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
