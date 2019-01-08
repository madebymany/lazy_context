defmodule LazyContext.Examples.DogsTest do
  @moduledoc """
  Tests for the extended functionality of LazyContext:
  * custom plural function name
  * preloads
  * create_or_update_uniqueness_keys
  """
  use LazyContext.DataCase

  alias LazyContext.Examples.Animals.Schemas.Dog
  alias LazyContext.Examples.Users.Schemas.User

  test "correct suffixes are used when plural provided" do
    defmodule PluralTest do
      use LazyContext,
        schema: Dog,
        suffix: {:dog, :doggos}
    end

    insert_list(3, :dog)
    assert PluralTest.list_doggos() |> length() === 3
    dog = insert(:dog, name: "Gloria")
    assert %Dog{name: "Gloria"} = PluralTest.get_dog(dog.id)
  end

  test "preloads on list, get, get! when universal preload list provided" do
    defmodule SimplePreloadTest do
      use LazyContext,
        schema: Dog,
        suffix: :dog,
        preloads: [:owner]
    end

    dog = insert(:dog, owner: insert(:user, first_name: "Frank"))
    assert %Dog{owner: %User{first_name: "Frank"}} = SimplePreloadTest.list_dogs |> Enum.at(0)
    assert %Dog{owner: %User{first_name: "Frank"}} = SimplePreloadTest.get_dog(dog.id)
    assert %Dog{owner: %User{first_name: "Frank"}} = SimplePreloadTest.get_dog(%{id: dog.id})
    assert %Dog{owner: %User{first_name: "Frank"}} = SimplePreloadTest.get_dog!(dog.id)
    assert %Dog{owner: %User{first_name: "Frank"}} = SimplePreloadTest.get_dog!(%{id: dog.id})
  end

  test "preloads correctly when preload map provided" do
    defmodule MapPreloadTest do
      use LazyContext,
        schema: Dog,
        suffix: :dog,
        preloads: %{
          get!: [:owner]
        }
    end

    dog = insert(:dog, owner: insert(:user, first_name: "Frank"))
    assert %Dog{owner: %Ecto.Association.NotLoaded{}} = MapPreloadTest.list_dogs |> Enum.at(0)
    assert %Dog{owner: %Ecto.Association.NotLoaded{}} = MapPreloadTest.get_dog(dog.id)
    assert %Dog{owner: %Ecto.Association.NotLoaded{}} = MapPreloadTest.get_dog(%{id: dog.id})
    assert %Dog{owner: %User{first_name: "Frank"}} = MapPreloadTest.get_dog!(dog.id)
    assert %Dog{owner: %User{first_name: "Frank"}} = MapPreloadTest.get_dog!(%{id: dog.id})
  end

  test "create_or_update works correctly when create_or_update_uniqueness_keys provided" do
    defmodule CreateOrUpdateTest do
      use LazyContext,
        schema: Dog,
        suffix: :dog,
        create_or_update_uniqueness_keys: [:colour, :cuteness]
    end

    dog = insert(:dog, colour: "Black", cuteness: 47, name: "Bob")
    assert {:ok, updated_dog} = CreateOrUpdateTest.create_or_update_dog(%{colour: "Black", cuteness: 47})
    assert updated_dog.id === dog.id
    assert CreateOrUpdateTest.list_dogs() |> length() === 1

    assert {:ok, created_dog} = CreateOrUpdateTest.create_or_update_dog(%{id: dog.id, colour: "Purple", cuteness: 46})
    refute created_dog.id === dog.id
    assert CreateOrUpdateTest.list_dogs() |> length() === 2
  end

  test "functions are overridable" do
    defmodule OverridableTest do
      use LazyContext,
        schema: Dog,
        suffix: :dog

      def get_dog(id) do
        super(id)
      end
    end

    dog = insert(:dog)
    assert %Dog{} = OverridableTest.get_dog(dog.id)
  end
end
