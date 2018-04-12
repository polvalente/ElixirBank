defmodule Bank.Handlers.TransferProcessManager do
  use Commanded.ProcessManagers.ProcessManager,
    name: "TransferProcessManager",
    router: Bank.Router

  alias Bank.Commands.{
    SendTransfer,
    ReceiveTransfer
  }

  alias Bank.Events.{
    TransferSent,
    TransferReceived
  }

  defstruct [
    :transfer_id,
    :sender_id,
    :receiver_id,
    :amount,
    :status
  ]

  def interested?(%TransferRequested{transfer_id: transfer_id}), do: {:start, transfer_id}
  def interested?(%TransferSent{transfer_id: transfer_id}), do: {:continue, transfer_id}
  def interested?(%TransferReceived{transfer_id: transfer_id}), do: {:continue, transfer_id}
  def interested?(%TransferFailed{transfer_id: transfer_id}), do: {:stop, transfer_id}
  def interested?(%TransferFinished{transfer_id: transfer_id}), do: {:stop, transfer_id}
  def interested?(_), do: false

  def handle(%TransferProcessManager{}, %TransferRequested{transfer_id: transfer_id, sender_id: sender_id, receiver_id: receiver_id, amount: amount}) do
    %SendTransfer{sender_id: sender_id, transfer_id: transfer_id, amount: amount, receiver_id: receiver_id}
  end

  def handle(%TransferProcessManager{transfer_id: transfer_id, receiver_id: receiver_id, amount: amount, sender_id: sender_id}) do
    %ReceiveTransfer{receiver_id: receiver_id, amount: amount, transfer_id: transfer_id, sender_id: sender_id}
  end

  ## State Mutators
  
  def apply(%TransferProcessManager{} = transfer, %TransferRequested{transfer_id: transfer_id, sender_id: sender_id, receiver_id: receiver_id, amount: amount}) do
    %TransferProcessManager{transfer |
      transfer_id: transfer_id,
      sender_id: sender_id,
      receiver_id: receiver_id,
      amount: amount,
      status: :withdraw_money_from_sender_account
  end

  def apply(%TransferProcessManager{} = transfer, %TransferSent{}) do
    %TransferProcessManager{transfer |
      status: deposit_money_in_receiver_account
    }
  end
end
