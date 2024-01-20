defmodule Scam.AccountsTest do
  use Scam.DataCase

  alias Scam.Accounts

  describe "users" do
    alias Scam.Accounts.User

    import Scam.AccountsFixtures

    @invalid_attrs %{name: nil, surname: nil, date_of_birth: nil, city: nil, postal_code: nil, address_line_one: nil, country: nil, phone_number: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{name: "some name", surname: "some surname", date_of_birth: ~D[2024-01-19], city: "some city", postal_code: "some postal_code", address_line_one: "some address_line_one", country: "some country", phone_number: "some phone_number"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.name == "some name"
      assert user.surname == "some surname"
      assert user.date_of_birth == ~D[2024-01-19]
      assert user.city == "some city"
      assert user.postal_code == "some postal_code"
      assert user.address_line_one == "some address_line_one"
      assert user.country == "some country"
      assert user.phone_number == "some phone_number"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{name: "some updated name", surname: "some updated surname", date_of_birth: ~D[2024-01-20], city: "some updated city", postal_code: "some updated postal_code", address_line_one: "some updated address_line_one", country: "some updated country", phone_number: "some updated phone_number"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.name == "some updated name"
      assert user.surname == "some updated surname"
      assert user.date_of_birth == ~D[2024-01-20]
      assert user.city == "some updated city"
      assert user.postal_code == "some updated postal_code"
      assert user.address_line_one == "some updated address_line_one"
      assert user.country == "some updated country"
      assert user.phone_number == "some updated phone_number"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
