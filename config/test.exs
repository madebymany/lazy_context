use Mix.Config

config :lazy_context,
  ecto_repos: [LazyContext.Examples.Repo],
  repo: LazyContext.Examples.Repo

# Configure your database
config :lazy_context, LazyContext.Examples.Repo,
  pool_size: 10,
  username: "postgres",
  password: "postgres",
  database: "lazy_config_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :info
