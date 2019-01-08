defmodule LazyContext.Examples.Users do
  @moduledoc """
  An example context to demonstrate basic use of the LazyContext library
  """

  alias LazyContext.Examples.Users.Schemas.User

  use LazyContext,
    schema: User,
    suffix: :user
end
