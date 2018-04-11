defmodule Bank.Aggregates.Account do
  defstruct []
  alias Bank.Commands.AddFunds
  alias Bank.Events.FundsAdded

  # Add Funds
  def execute(_, %AddFunds{} = cmd) 
    when is_valid(cmd.amount)
  do
    %FundsAdded{account_id: cmd.account_id, amount: amount}
  end

  def execute(_, %AddFunds{}) do
    {:error, :invalid_amount}
  end

  # Receive Transfer
  def execute(_, %ReceiveTransfer{} = cmd)
    when is_valid(cmd.amount)
  do
    %TransferReceived{sender_account_id: cmd.sender_account_id, receiver_account_id: cmd.receiver_account_id, amount: amount}
  end

  def execute(_, %ReceiveTransfer{}) do
    {:error, :invalid_amount}
  end

  # Send Transfer
  def execute(%Account{balance: balance}, %SendTransfer{amount: amount} = cmd)
    when is_valid(amount) and has_funds(amount, balance)
  do
    %TransferSent{sender_account_id: cmd.sender_account_id, receiver_account_id: cmd.receiver_account_id, amount: amount}
  end

  def execute(%Account{balance: balance}, %SendTransfer{amount: amount}) do
    error_type = cond do
      !is_valid(amount) -> :invalid_amount
      !has_funds(amount, balance) -> :insufficient_funds
    end
    {:error, error_type}
  end
  


  # Other functions
  def apply(state, _), do: state

  defp is_valid(amount) do
    (rem(amount, 10) == 0) and (amount > 10)
  end

  defp has_funds(amount, balance) do
    balance - amount >= 0
  end
end
