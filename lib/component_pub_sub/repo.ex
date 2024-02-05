defmodule CompPS.Repo do
  use Ecto.Repo,
    otp_app: :component_pub_sub,
    adapter: Ecto.Adapters.Postgres
end
