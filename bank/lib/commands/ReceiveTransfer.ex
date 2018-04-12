defmodule Bank.Commands.ReceiveTransfer do
  defstruct [:sender_id, :receiver_id, :amount, :transfer_id]
end
