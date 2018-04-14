defmodule Bank.Web.GraphQL.Resolvers.Account do

  def get_account(_parent, %{id: id}, _resolution) do
    case Bank.Repo.get(Bank.Schemas.Account, id) do
      nil -> {:error, "Account with ID '#{id}' not found"} 
      account -> {:ok, %{id: account.account_id, balance: account.balance}}
    end
  end

  def add_funds(_parent, %{amount: amount, account_id: id}, _resolution) do
    case Bank.add_funds(id, amount) do
      {:error, error} -> {:error, error}
      _ -> get_account(nil, %{id: id}, nil) 
    end
  end

  def transfer(_parent, %{from_id: sender, to_id: receiver, amount: amount}, _resolution) do
    case Bank.transfer(sender, receiver, amount) do
      {:error, error} -> {:error, error}
      _ -> get_account(nil, %{id: sender}, nil) 
    end
  end
end
