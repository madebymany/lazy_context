defmodule LazyContext.Examples.Users.Schemas.User do
  @moduledoc """
  An example user schema
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias LazyContext.Examples.Users.Schemas.User
  alias LazyContext.Examples.Animals.Schemas.{Cat, Dog, Ferret}

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :age, :integer
    field :email, :string

    has_many :cats, Cat, foreign_key: :owner_id
    has_many :dogs, Dog, foreign_key: :owner_id
    has_many :ferrets, Ferret, foreign_key: :owner_id
  end

  @spec changeset(%User{}, map()) :: Ecto.Changeset.t()
  def changeset(user, attrs) do
    cast(user, attrs, [:first_name, :last_name, :age, :email])
  end
end
