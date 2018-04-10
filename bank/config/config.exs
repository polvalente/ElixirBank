# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :commanded,
  event_store_adapter: Commanded.EventStore.Adapters.EventStore

import_config "#{Mix.env()}.exs"
