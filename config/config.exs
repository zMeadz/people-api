# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :people, :services,
  salesloft: [
    base_url: "https://api.salesloft.com",
    version: "v2"
  ]

# Configures the endpoint
config :people, PeopleWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wsLh9jSBfeVqaFA2VRw/FWIPiNKYQ2woi9UwWt/zIitdbiaG3pfhoQgrzdApd82x",
  render_errors: [view: PeopleWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: People.PubSub,
  live_view: [signing_salt: "Jzvud/PM"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
