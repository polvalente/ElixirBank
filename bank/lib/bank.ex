defmodule Bank do
  def add_funds(id, amount) do
    case BankRouter.dispatch(%AddFunds{account_id: id, amount: amount}) do
  end

  def balance(id) do
  end

  def transfer(sender_id, receiver_id, amount) do
  end

  def statement(id) do
  end
end
