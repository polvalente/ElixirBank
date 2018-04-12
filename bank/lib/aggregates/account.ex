defmodule Bank.Aggregates.Account do
  defstruct [:account_id, :balance]
  alias Bank.Commands.{
    AddFunds,
    ReceiveTransfer,
    SendTransfer
  }

  alias Bank.Events.{
    FundsAdded,
    TransferSent,
    TransferReceived
  }

  alias __MODULE__

  # Add Funds
  def execute(_, %AddFunds{} = cmd) do
    cond do
      !is_valid?(cmd.amount) -> {:error, :invalid_amount}
      true -> %FundsAdded{account_id: cmd.account_id, amount: cmd.amount}
    end
  end

  # Receive Transfer
  def execute(_, %ReceiveTransfer{} = cmd) do
    cond do
      !is_valid?(cmd.amount) -> {:error, :invalid_amount}
      true -> %TransferReceived{sender_id: cmd.sender_id, receiver_id: cmd.receiver_id, amount: cmd.amount}
    end
  end

  # Send Transfer
  def execute(%Account{balance: balance}, %SendTransfer{amount: amount} = cmd) do
    cond do
      !is_valid?(amount) -> {:error, :invalid_amount}
      !has_funds?(amount, balance) -> {:error, :insufficient_funds}
      true -> %TransferSent{sender_id: cmd.sender_id, receiver_id: cmd.receiver_id, amount: amount, transfer_id: cmd.transfer_id}
    end
  end

  # Other functions
  def apply(state, _), do: state

  def is_valid?(amount) do
     (rem(amount, 10) == 0) and (amount > 0)
  end

  defp has_funds?(amount, balance) do
    true #balance - amount >= 0
  end

end
