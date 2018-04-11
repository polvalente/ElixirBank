defmodule Bank.Events.TransferSent do
  defstruct [:sender_account_id, :receiver_account_id, :amount]
end
