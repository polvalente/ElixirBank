defmodule Bank.Events.TransferSent do
  defstruct [:sender_id, :receiver_id, :amount, :transfer_id]
end
