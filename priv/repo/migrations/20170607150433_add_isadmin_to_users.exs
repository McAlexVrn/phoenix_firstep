defmodule Firstep.Repo.Migrations.AddIsadminToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :is_admin, :boolean, default: false, null: false
      add :access_token, :binary
      add :access_token_expires_at, :utc_datetime
      add :refresh_token, :binary
     end
  end
end
