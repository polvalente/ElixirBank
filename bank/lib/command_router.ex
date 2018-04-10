defmodule BankRouter do
  use Commanded.Commands.Router
  alias Bank.Aggregates.Account
  alias Bank.Commands.AddFunds

  dispatch AddFunds, to: Account, identity: :account_id
end
