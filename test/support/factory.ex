defmodule LazyContext.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: LazyContext.Examples.Repo

  def user_factory do
    %LazyContext.Examples.Users.Schemas.User{
      first_name: "some first_name",
      last_name: "some last_name",
      age: sequence(:age, & &1),
      email: sequence(:email, &generate_email/1)
    }
  end

  def cat_factory do
    %LazyContext.Examples.Animals.Schemas.Cat{
      name: "Frank",
      colour: "Tabby",
      cuteness: 9,
      owner: build(:user)
    }
  end

  def dog_factory do
    %LazyContext.Examples.Animals.Schemas.Dog{
      name: "Doris",
      colour: "Black",
      cuteness: 5,
      owner: build(:user)
    }
  end

  def ferret_factory do
    %LazyContext.Examples.Animals.Schemas.Ferret{
      name: "Freya",
      colour: "Brown",
      cuteness: 12,
      owner: build(:user)
    }
  end
    
  defp generate_email(index) do
    "person_#{index}@example.com"
  end
end
