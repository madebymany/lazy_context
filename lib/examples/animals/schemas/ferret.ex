defmodule LazyContext.Examples.Animals.Schemas.Ferret do
  @moduledoc """
  An example ferret schema
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias LazyContext.Examples.Animals.Schemas.Ferret
  alias LazyContext.Examples.Users.Schemas.User

  schema "ferrets" do
    field :name, :string
    field :colour, :string
    field :cuteness, :integer
    field :social_security_number, :integer

    belongs_to :owner, User
  end

  @spec changeset(%Ferret{}, map()) :: Ecto.Changeset.t()
  def changeset(ferret, attrs) do
    ferret
    |> cast(attrs, [:name, :colour, :cuteness, :owner_id])
    |> unique_constraint(:social_security_number)
  end
end
