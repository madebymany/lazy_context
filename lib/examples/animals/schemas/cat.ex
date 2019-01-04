defmodule LazyContext.Examples.Animals.Schemas.Cat do
  @moduledoc """
  An example cat schema
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias LazyContext.Examples.Animals.Schemas.Cat
  alias LazyContext.Examples.Users.Schemas.User

  schema "cats" do
    field :name, :string
    field :colour, :string
    field :cuteness, :integer

    belongs_to :owner, User
  end

  @spec changeset(%Cat{}, map()) :: Ecto.Changeset.t()
  def changeset(cat, attrs) do
    cast(cat, attrs, [:name, :colour, :cuteness, :owner_id])
  end
end
