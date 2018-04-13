defmodule Bank.Handlers.TransferProcessManager do
  use Commanded.ProcessManagers.ProcessManager,
    name: "TransferProcessManager",
    router: Bank.Router

  alias Bank.Commands.{
    ReceiveTransfer,
    FailTransfer
  }

  alias Bank.Events.{
    TransferSent,
    TransferReceived,
    TransferFailed
  }

  alias __MODULE__

  defstruct [
    :transfer_id,
    :sender_id,
    :receiver_id,
    :amount,
    :status
  ]

  def interested?(%TransferSent{transfer_id: transfer_id}) do 
    {:continue, transfer_id}
  end

  def interested?(%TransferReceived{transfer_id: transfer_id}) do 
    {:stop, transfer_id}
  end
  def interested?(%TransferFailed{transfer_id: transfer_id}) do
    {:continue, transfer_id}
  end
  def interested?(_), do: false

  def handle(%TransferProcessManager{}, %TransferSent{transfer_id: transfer_id, sender_id: sender_id, receiver_id: receiver_id, amount: amount}) do
    %ReceiveTransfer{sender_id: sender_id, receiver_id: receiver_id, amount: amount, transfer_id: transfer_id}
  end

  def handle(%TransferProcessManager{}, %TransferFailed{} = evt) do
    %FailTransfer{
      account_id: evt.account_id, 
      amount: evt.amount, 
      reason: evt.reason,
      transfer_id: evt.transfer_id
    }
  end

  ## State Mutators
  
  def apply(%TransferProcessManager{} = transfer, %TransferSent{}) do
    %TransferProcessManager{transfer |
      status: :deposit_money_in_receiver_account
    }
  end

  def error({:error, reason}, %ReceiveTransfer{} = cmd, context) do
    {:continue, [%FailTransfer{account_id: cmd.sender_id, amount: cmd.amount, reason: reason, transfer_id: cmd.transfer_id}], context}
  end

  def error({:error, _reason}, _failed_command, %{context: %{failures: failures}}) when 
    failures >= 2 
  do
    {:stop, :too_many_failures}
  end

  def error({:error, _failure}, _failed_command, %{context: context}) do
    context = Map.update(context, :failures, 1, fn failures -> failures + 1 end)
    {:retry, context}
  end
end
