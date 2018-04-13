defmodule Bank.Events.Helper do
  alias Bank.Events, as: E
  def to_statement_line(%E.FundsAdded{} = event), do: "+ #{event.amount}"
  def to_statement_line(%E.TransferReceived{} = event), do: "+ #{event.amount}"
  def to_statement_line(%E.TransferSent{} = event), do: "- #{event.amount}"
  def to_statement_line(_), do: ""

end
