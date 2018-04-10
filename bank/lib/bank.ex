defmodule Bank do
  alias Bank.Commands.AddFunds
  alias Bank.Schemas.Account
  def add_funds(id, amount) do
    BankRouter.dispatch(%AddFunds{account_id: id, amount: amount})
  end

  def balance(id) do
    account = Bank.Repo.get(Account, id)
    account.balance
  end

  def transfer(sender_id, receiver_id, amount) do
  end

  def statement(id) do
  end
end
