# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :firstep,
  ecto_repos: [Firstep.Repo]

# Configures the endpoint
config :firstep, Firstep.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "W3m6U11zry5ZXWb1/BYplR5DZGJ0Evn6WkFNA8EvvKHSpyvl/ILiVFLltMHh3hk6",
  render_errors: [view: Firstep.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Firstep.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Firstep",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  secret_key: "OUE7HdJ9S908H9lxjE52Xhoufo3VIvyf4B2HRZ7YnJo5YgUGyg7dj8AtF7uh9IR1",
  serializer: Firstep.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
