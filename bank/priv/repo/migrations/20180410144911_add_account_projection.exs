defmodule Bank.Repo.Migrations.AddAccountProjection do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :account_id, :string, primary_key: true
      add :balance, :integer

      timestamps()
    end
  end
end
