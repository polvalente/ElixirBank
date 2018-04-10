defmodule Bank.Aggregates.Account do
  defstruct []
  alias Bank.Commands.AddFunds
  alias Bank.Events.FundsAdded

  def execute(_, %AddFunds{amount: amount} = cmd) 
    when rem(amount,10) == 0
  do
    %FundsAdded{account_id: cmd.account_id, amount: amount}
  end

  def execute(_, %AddFunds{}) do
    {:error, :invalid_amount}
  end

  def apply(state, _), do: state
end
