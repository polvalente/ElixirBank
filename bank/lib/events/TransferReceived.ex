defmodule Bank.Events.TransferReceived do
  defstruct [:sender_id, :receiver_id, :amount, :transfer_id]
end
