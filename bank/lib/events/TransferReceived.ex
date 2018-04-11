defmodule Bank.Events.TransferReceived do
  defstruct [:sender_account_id, :receiver_account_id, :amount]
end
