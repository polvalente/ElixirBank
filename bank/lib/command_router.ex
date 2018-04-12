defmodule Bank.Router do
  use Commanded.Commands.Router
  alias Bank.Aggregates.Account
  alias Bank.Commands.{
    AddFunds,
    SendTransfer,
    ReceiveTransfer,
  }

  dispatch (
    [
      AddFunds,
      SendTransfer,
      ReceiveTransfer
    ],
    to: Account, identity: :account_id
  )
end
