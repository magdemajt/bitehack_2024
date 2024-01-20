defmodule Scam.Repo do
  use Ecto.Repo,
    otp_app: :scam,
    adapter: Ecto.Adapters.Postgres
end
