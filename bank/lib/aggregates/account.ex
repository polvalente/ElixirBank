defmodule Bank.Aggregates.Account do
  defstruct [:account_id, balance: 0]
  alias Bank.Commands.{
    AddFunds,
    ReceiveTransfer,
    SendTransfer,
    FailTransfer
  }

  alias Bank.Events.{
    FundsAdded,
    TransferSent,
    TransferReceived,
    TransferFailed
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
      true -> %TransferReceived{sender_id: cmd.sender_id, receiver_id: cmd.receiver_id, amount: cmd.amount, transfer_id: cmd.transfer_id}
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

  # Fail Transfer
  def execute(%Account{}, %FailTransfer{account_id: account_id, amount: amount, reason: reason, transfer_id: transfer_id}) do
    %TransferFailed{
      account_id: account_id, 
      amount: amount, 
      reason: reason,
      transfer_id: transfer_id
    }
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
  def apply(%Account{} = account, %TransferFailed{} = cmd) do
    %Account{account | balance: account.balance + cmd.amount}
  end
  def apply(state, _), do: state

  # Other functions

  def is_valid?(amount \\ 0) when amount > 0 do
     (rem(amount, 10) == 0)
  end
  defp is_valid?(_, _), do: false

  defp has_funds?(amount \\ 0 , balance \\ 0) when
    amount > 0 and balance >= 0
  do
    balance - amount >= 0
  end

  defp has_funds?(_, _), do: false

end
