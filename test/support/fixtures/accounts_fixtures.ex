defmodule Scam.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Scam.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        address_line_one: "some address_line_one",
        city: "some city",
        country: "some country",
        date_of_birth: ~D[2024-01-19],
        name: "some name",
        phone_number: "some phone_number",
        postal_code: "some postal_code",
        surname: "some surname"
      })
      |> Scam.Accounts.create_user()

    user
  end
end
