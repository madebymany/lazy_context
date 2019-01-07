defmodule LazyContext.Examples.UsersTest do
  @moduledoc """
  This module tests the basic functionality of LazyContext - that all the
  functions are implemented and work as expected
  """

  use LazyContext.DataCase

  alias LazyContext.Examples.Users
  alias LazyContext.Examples.Users.Schemas.User

  describe "list_users/0" do
    test "returns all users" do
      insert_list(3, :user)
      assert Users.list_users() |> length === 3
    end
  end

  describe "get_user/1" do
    test "returns correct user from ID" do
      insert_list(3, :user)
      user = insert(:user, first_name: "Stanley")
      assert %User{first_name: "Stanley"} = Users.get_user(user.id)
    end

    test "returns nil if user with id doesn't exist" do
      assert Users.get_user(123) === nil
    end

    test "returns correct user from attrs" do
      insert_list(3, :user)
      insert(:user, first_name: "Sue", last_name: "McSue")
      assert %User{first_name: "Sue"} = Users.get_user(%{last_name: "McSue"})
    end

    test "returns nil if user with id from attrs doesn't exist" do
      assert Users.get_user(%{id: 123}) === nil
    end
  end

  describe "get_user!/1" do
    test "returns correct user from ID" do
      insert_list(3, :user)
      user = insert(:user, first_name: "Stanley")
      assert %User{first_name: "Stanley"} = Users.get_user!(user.id)
    end

    test "raises if user with id doesn't exist" do
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(123) end
    end

    test "returns correct user from attrs" do
      insert_list(3, :user)
      insert(:user, first_name: "Sue", last_name: "McSue")
      assert %User{first_name: "Sue"} = Users.get_user!(%{last_name: "McSue"})
    end

    test "throws if user with id from attrs doesn't exist" do
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(%{id: 123}) end
    end
  end

  describe "create_user/1" do
    test "creates user" do
      params = params_for(:user)
      assert {:ok, %User{}} = Users.create_user(params)
      assert Users.list_users() |> length() === 1
    end

    test "returns error tuple if invalid attrs passed" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(%{age: "not a number"})
      assert Users.list_users() |> length() === 0
    end
  end

  describe "create_user!/1" do
    test "creates user" do
      params = params_for(:user)
      assert %User{} = Users.create_user!(params)
      assert Users.list_users() |> length() === 1
    end

    test "raises  if invalid attrs passed" do
      assert_raise Ecto.InvalidChangesetError, fn -> Users.create_user!(%{age: "not a number"}) end
      assert Users.list_users() |> length() === 0
    end
  end

  describe "create_or_update_user/1" do
    test "creates user when it doesn't exist" do
      params = params_for(:user)
      assert {:ok, %User{}} = Users.create_or_update_user(params)
      assert Users.list_users() |> length() === 1
    end

    test "update user when user exists with id" do
      user = insert(:user, first_name: "Bob")
      assert {:ok, updated_user} = Users.create_or_update_user(%{id: user.id, first_name: "Sue"})
      assert updated_user.id === user.id
      assert updated_user.first_name === "Sue"
      assert Users.list_users() |> length() === 1
    end
  end

  describe "create_or_update_user!/1" do
    test "creates user when it doesn't exist" do
      params = params_for(:user)
      assert %User{} = Users.create_or_update_user!(params)
      assert Users.list_users() |> length() === 1
    end

    test "update user when user exists with id" do
      user = insert(:user, first_name: "Bob")
      assert updated_user = Users.create_or_update_user!(%{id: user.id, first_name: "Sue"})
      assert updated_user.id === user.id
      assert updated_user.first_name === "Sue"
      assert Users.list_users |> length() === 1
    end
  end

  describe "update_user/1" do
    test "updates user" do
      user = insert(:user, first_name: "Bob")

      assert {:ok, updated_user} = Users.update_user(user, %{first_name: "Sue"})
      assert updated_user.first_name === "Sue"
      assert Users.list_users |> length() === 1
    end
  end

  describe "update_user!/1" do
    test "updates user" do
      user = insert(:user, first_name: "Bob")

      assert updated_user = Users.update_user!(user, %{first_name: "Sue"})
      assert updated_user.first_name === "Sue"
      assert Users.list_users |> length() === 1
    end
  end

  describe "delete_user/1" do
    test "deletes user" do
      user = insert(:user, first_name: "Bob")

      assert {:ok, %User{}} = Users.delete_user(user)
      assert Users.list_users |> length() === 0
    end
  end

  describe "delete_user!/1" do
    test "deletes user" do
      user = insert(:user, first_name: "Bob")

      assert %User{} = Users.delete_user!(user)
      assert Users.list_users |> length() === 0
    end
  end

  describe "change_user/2" do
    test "reutrns an ecto changeset" do
      user = insert(:user)
      assert %Ecto.Changeset{} = Users.change_user(user, %{})
    end
  end

end
