defmodule LazyContext.Examples.Animals do
  @moduledoc """
  An example context to demonstrate features the LazyContext library
  """

  alias LazyContext.Examples.Animals.Schemas.{Cat, Dog, Ferret}

  use LazyContext,
    schema: Cat,
    suffix: :cat,
    preloads: %{
      get: [:owner],
      get!: [:owner]
    }

  use LazyContext,
    schema: Dog,
    suffix: {:dog, :doggos},
    preloads: [:owner]

  use LazyContext,
    schema: Ferret,
    suffix: :ferret,
    preloads: [:owner],
    create_or_update_uniqueness_keys: [:social_security_number]
end
