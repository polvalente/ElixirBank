defmodule Bank.Events.TransferFailed do
  defstruct [:account_id, :transfer_id, :reason, amount: 0]
end
