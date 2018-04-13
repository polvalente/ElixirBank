defmodule Bank.Commands.FailTransfer do
  defstruct [:account_id, :amount, :transfer_id, :reason]
end
