defmodule Bank.AccountProjector do
  use Commanded.Projections.Ecto,
    name: "account_projection"

  alias Bank.Schemas.Account
  alias Bank.Events.{
    FundsAdded,
    TransferReceived,
    TransferSent,
    TransferFailed
  }

  project %FundsAdded{account_id: account_id, amount: amount}, _metadata do
    case Bank.Repo.get(Account, account_id) do
      nil -> create_account(multi, account_id, amount)
      _ -> increase_balance(multi, account_id, amount)
    end
  end

  project %TransferReceived{receiver_id: receiver_id, amount: amount}, _metadata do
    case Bank.Repo.get(Account, receiver_id) do
      nil -> multi
      _ -> increase_balance(multi, receiver_id, amount)
    end
  end

  project %TransferSent{sender_id: sender_id, amount: amount}, _metadata do
    case Bank.Repo.get(Account, sender_id) do
      nil -> multi
      _ -> decrease_balance(multi, sender_id, amount)
    end
  end

  project %TransferFailed{account_id: account_id, amount: amount}, _metadata do
    case Bank.Repo.get(Account, account_id) do
      nil -> multi
      _ -> increase_balance(multi, account_id, amount)
    end
  end

  defp create_account(multi, account_id, amount) do
    Ecto.Multi.insert(multi, :account_projection, %Account{account_id: account_id, balance: amount})
  end

  defp increase_balance(multi, account_id, amount) do
    Ecto.Multi.update_all(
      multi,
      :increase_balance,
      account_query(account_id),
      inc: [balance: amount]
    )
  end

  defp decrease_balance(multi, account_id, amount) do
    Ecto.Multi.update_all(
      multi,
      :increase_balance,
      account_query(account_id),
      inc: [balance: -amount]
    )
  end

  defp account_query(account_id) do
    import Ecto.Query
    from a in Account, where: a.account_id == ^account_id
  end
end
