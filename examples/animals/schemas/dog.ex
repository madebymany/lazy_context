defmodule LazyContext.Examples.Animals.Schemas.Dog do
  @moduledoc """
  An example dog schema
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias LazyContext.Examples.Animals.Schemas.Dog
  alias LazyContext.Examples.Users.Schemas.User

  schema "dogs" do
    field :name, :string
    field :colour, :string
    field :cuteness, :integer

    belongs_to :owner, User
  end

  @spec changeset(%Dog{}, map()) :: Ecto.Changeset.t()
  def changeset(dog, attrs) do
    cast(dog, attrs, [:name, :colour, :cuteness, :owner_id])
  end
end
