defmodule Bank.Schemas.Account do
  use Ecto.Schema

  @primary_key {:account_id, :string, autogenerate: false}
  schema "accounts" do
    field :balance, :integer
    timestamps()
  end
end
