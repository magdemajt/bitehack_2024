defmodule Scam.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :surname, :string
    field :date_of_birth, :date
    field :city, :string
    field :postal_code, :string
    field :address_line_one, :string
    field :country, :string
    field :phone_number, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :surname, :date_of_birth, :city, :postal_code, :address_line_one, :country, :phone_number])
    |> validate_required([:name, :surname, :date_of_birth, :city, :postal_code, :address_line_one, :country, :phone_number])
  end
end
