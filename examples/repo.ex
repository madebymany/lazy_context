defmodule LazyContext.Examples.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :lazy_context,
    adapter: Ecto.Adapters.Postgres
end
