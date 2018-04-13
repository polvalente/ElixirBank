defmodule Bank.AccountBalanceHandler do
  use Commanded.Event.Handler, name: __MODULE__
  alias Bank.Events.{
    FundsAdded,
    TransferReceived,
    TransferSent,
  }

  def init do
    with {:ok, _pid} <- Agent.start_link(fn -> 0 end, name: __MODULE__) do
      :ok
    end
  end

  #FundsAdded event handlers
  def handle(%FundsAdded{amount: amount}, _metadata) do
    Agent.update(__MODULE__, fn balance -> balance + amount end)
  end

  #TransferSent event handlers
  def handle(%TransferSent{amount: amount}, _metadata) do
    Agent.update(__MODULE__, fn balance -> balance - amount end)
  end
  
  #TransferReceived event handlers
  def handle(%TransferReceived{amount: amount}, _metadata) do
    Agent.update(__MODULE__, fn balance -> balance + amount end)
  end

  def current_balance do
    Agent.get(__MODULE__, fn balance -> balance end)
  end
end
