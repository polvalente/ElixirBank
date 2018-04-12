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
    %TransferReceived{sender_id: cmd.sender_id, receiver_id: cmd.receiver_id, amount: amount}
  end

  def execute(_, %ReceiveTransfer{} = transfer) do
    %TransferFailed{transfer_id: transfer.id, reason: :invalid_amount}
  end

  # Send Transfer
  def execute(%Account{balance: balance}, %SendTransfer{amount: amount} = cmd)
    when is_valid(amount) and has_funds(amount, balance)
  do
    %TransferSent{sender_id: cmd.sender_id, receiver_id: cmd.receiver_id, amount: amount}
  end

  def execute(%Account{balance: balance}, %SendTransfer{amount: amount} = transfer) do
    error_type = cond do
      !is_valid(amount) -> :invalid_amount
      !has_funds(amount, balance) -> :insufficient_funds
    end
    %TransferFailed{transfer_id: transfer.id, reason: error_type}
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
