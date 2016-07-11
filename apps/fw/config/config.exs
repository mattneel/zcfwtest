# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :web, Web.Endpoint,
  http: [port: 80],
  url: [host: "localhost", port: 80],
  secret_key_base: "23LqX+jFUjYnCBqC6e8iTqRSz+RIh+J6+bcOwi5g6UvYMRhdxfEJhQGnmxSfpx1K",
  root: Path.dirname(__DIR__),
  server: true,
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Nerves.PubSub]

config :logger, level: :debug

config :nerves_interim_wifi,
  regulatory_domain: "US"

import_config "#{Mix.env}.exs"
