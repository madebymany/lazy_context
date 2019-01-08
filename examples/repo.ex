defmodule LazyContext.Examples.Repo do
  use Ecto.Repo,
    otp_app: :lazy_context,
    adapter: Ecto.Adapters.Postgres

  # @doc """
  # Load poolsize from env at run time (even in a release), as it needs a type convertion
  # """
  # def init(_, opts) do
  #   {:ok, Keyword.put(opts, :pool_size, String.to_integer(System.get_env("POOL_SIZE") || "10"))}
  # end
end
