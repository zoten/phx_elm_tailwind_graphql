defmodule Scmp.Repo do
  use Ecto.Repo,
    otp_app: :scmp,
    adapter: Ecto.Adapters.Postgres
end
