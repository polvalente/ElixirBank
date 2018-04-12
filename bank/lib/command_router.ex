defmodule Bank.Router do
  use Commanded.Commands.Router
  alias Bank.Aggregates.Account
  alias Bank.Commands.{
    AddFunds,
    SendTransfer,
    ReceiveTransfer,
  }

  dispatch(AddFunds, to: Account, identity: :account_id)
  dispatch(SendTransfer, to: Account, identity: :sender_id)
  dispatch(ReceiveTransfer, to: Account, identity: :receiver_id)
end
