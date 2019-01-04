# {:ok, _} = Application.ensure_all_started(:ex_machina)

ExUnit.start()

{:ok, _pid} = LazyContext.Examples.Repo.start_link
Ecto.Adapters.SQL.Sandbox.mode(LazyContext.Examples.Repo, :manual)


