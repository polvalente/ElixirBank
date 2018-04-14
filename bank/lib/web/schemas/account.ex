defmodule Bank.Web.GraphQL.Account do
  use Absinthe.Schema.Notation

  object :account do
    field :id, :id
    field :balance, :integer
  end
end
