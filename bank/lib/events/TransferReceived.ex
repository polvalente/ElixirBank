defmodule Bank.Events.TransferReceived do
  defstruct [:sender_id, :receiver_id, :amount]
end
