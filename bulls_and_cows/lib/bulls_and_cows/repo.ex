defmodule BullsAndCows.Repo do
  use Ecto.Repo,
    otp_app: :bulls_and_cows,
    adapter: Ecto.Adapters.Postgres
end
