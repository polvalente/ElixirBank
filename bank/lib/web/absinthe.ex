defmodule Bank.Web.GraphQL.Schema do
  use Absinthe.Schema
  import_types Bank.Web.GraphQL.Account

  alias Bank.Web.GraphQL.Resolvers

  query do

    @desc "Get accounts with given ID"
    field :account, :account do
      arg :id, non_null(:id)
      resolve &Resolvers.Account.get_account/3
    end

  end

  mutation do

    @desc "Add funds to account with given ID"
    field :add_funds, type: :account do
      arg :account_id, non_null(:id)
      arg :amount, non_null(:integer)

      resolve &Resolvers.Account.add_funds/3
    end

    @desc "Transfer 'amount' from 'fromId' to 'toId'"
    field :transfer, type: :account do
      arg :from_id, non_null(:id)
      arg :to_id, non_null(:id)
      arg :amount, non_null(:integer)

      resolve &Resolvers.Account.transfer/3
    end

  end
end
