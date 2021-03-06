# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :cerberus,
  ecto_repos: [Cerberus.Repo]

# Configures the endpoint
config :cerberus, Cerberus.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ECVC2EVu7OTm4xZFr17rgG0ufoou7NPIigJoxS32lsIDzjamL4DQtaBsWp/8m6Cm",
  render_errors: [view: Cerberus.ErrorView, accepts: ~w(json)],
  pubsub: [name: Cerberus.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure phoenix generators
config :phoenix, :generators,
  binary_id: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
