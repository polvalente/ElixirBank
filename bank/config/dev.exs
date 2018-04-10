use Mix.Config

config :eventstore, EventStore.Storage,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "postgres",
  password: "postgres",
  database: "eventstore_dev",
  hostname: "localhost",
  pool_size: 10

config :bank, ecto_repos: [Bank.Repo]

config :bank, Bank.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "account_dev",
  hostname: "localhost",
  port: "5432",
  username: "postgres",
  password: "postgres"

config :commanded_ecto_projections,
  repo: Bank.Repo
