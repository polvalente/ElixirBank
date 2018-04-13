defmodule Bank.GraphQL.Account do
  use Absinthe.Schemas.Notation

  object :account do
    field :id, :id
    field :balance, :integer
  end
end
