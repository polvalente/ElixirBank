defmodule Bank.Commands.SendTransfer do
  defstruct [:sender_id, :receiver_id, :amount, :transfer_id]
end
