defmodule Bank.Commands.ReceiveTransfer do
  defstruct [:sender_account_id, :receiver_account_id, :amount]
end
