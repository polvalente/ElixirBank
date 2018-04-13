defmodule Bank.Aggregates.Account do
  defstruct [:account_id, balance: 0]
  alias Bank.Commands.{
    AddFunds,
    ReceiveTransfer,
    SendTransfer,
  }

  alias Bank.Events.{
    FundsAdded,
    TransferSent,
    TransferReceived,
  }

  alias __MODULE__

  # Add Funds
  def execute(_, %AddFunds{} = cmd) do
    cond do
      !is_valid?(cmd.amount, :strict) -> {:error, :invalid_amount}
      true -> %FundsAdded{account_id: cmd.account_id, amount: cmd.amount}
    end
  end


  # Receive Transfer
  def execute(_, %ReceiveTransfer{} = cmd) do
    cond do
      !is_valid?(cmd.amount) -> {:error, :invalid_amount}
      true -> %TransferReceived{sender_id: cmd.sender_id, receiver_id: cmd.receiver_id, amount: cmd.amount, transfer_id: cmd.transfer_id}
    end
  end


  # Send Transfer
  def execute(%Account{balance: balance}, %SendTransfer{amount: amount} = cmd) do
    cond do
      !has_funds?(amount, balance) -> {:error, :insufficient_funds}
      true -> %TransferSent{sender_id: cmd.sender_id, receiver_id: cmd.receiver_id, amount: amount, transfer_id: cmd.transfer_id}
    end
  end

  # Apply Events

  def apply(%Account{} = account, %FundsAdded{} = cmd) do
    %Account{account | balance: account.balance + cmd.amount}
  end
  def apply(%Account{} = account, %TransferReceived{} = cmd) do
    %Account{account | balance: account.balance + cmd.amount}
  end
  def apply(%Account{} = account, %TransferSent{} = cmd) do
    %Account{account | balance: account.balance - cmd.amount}
  end
  def apply(state, _), do: state

  # Other functions

  defp is_valid?(amount) when amount > 0, do: true
  defp is_valid?(_), do: false
  defp is_valid?(amount, :strict) when amount > 0, do: (rem(amount, 10) == 0)
  defp is_valid?(_,_), do: false

  defp has_funds?(amount, balance) when
    amount > 0 and balance >= 0
  do
    balance - amount >= 0
  end
  defp has_funds?(_, _), do: false

end
