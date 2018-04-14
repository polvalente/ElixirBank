defmodule Bank.Web.GraphQL.Resolvers.Account do
  def get_account(_parent, %{id: id}, _resolution) do
    case Bank.Repo.get(Bank.Schemas.Account, id) do
      nil -> {:error, "Account with ID '#{id}' not found"} 
      account -> {:ok, %{id: account.account_id, balance: account.balance}}
    end
  end
end
