ExUnit.start()

{:ok, _pid} = LazyContext.Examples.Repo.start_link
Ecto.Adapters.SQL.Sandbox.mode(LazyContext.Examples.Repo, :manual)


