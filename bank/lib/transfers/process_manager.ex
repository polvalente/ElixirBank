defmodule Bank.Handlers.TransferProcessManager do
  use Commanded.ProcessManagers.ProcessManager,
    name: "TransferProcessManager",
    router: Bank.Router

  alias Bank.Commands.{
    ReceiveTransfer
  }

  alias Bank.Events.{
    TransferSent,
    TransferReceived
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
    IO.puts("++++++")
    IO.puts("transfer sent!")
    IO.puts("++++++")
    {:continue, transfer_id}
  end

  def interested?(%TransferReceived{transfer_id: transfer_id}) do 
    {:continue, transfer_id}
  end
  # def interested?(_), do: false

  def handle(%TransferProcessManager{}, %TransferSent{transfer_id: transfer_id, sender_id: sender_id, receiver_id: receiver_id, amount: amount}) do
    %ReceiveTransfer{sender_id: sender_id, receiver_id: receiver_id, amount: amount, transfer_id: transfer_id}
  end

  ## State Mutators
  
  def apply(%TransferProcessManager{} = transfer, %TransferSent{}) do
    %TransferProcessManager{transfer |
      status: :deposit_money_in_receiver_account
    }
  end
end
