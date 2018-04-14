defmodule Bank.Web.GraphQL.Schema do
  use Absinthe.Schema
  import_types Bank.Web.GraphQL.Account

  alias Bank.Web.GraphQL.Resolvers

  query do
    @desc "Get accounts with given id"
    field :account, :account do
      arg :id, non_null(:id)
      resolve &Resolvers.Account.get_account/3
    end
  end
end
