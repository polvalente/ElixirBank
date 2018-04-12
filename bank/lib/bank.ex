defmodule Bank do
  @type id :: String.t
  @spec add_funds(id, integer) :: :ok | {:error, any()}
  @spec balance(id) :: integer
  @spec transfer(id, id, integer) :: :ok | {:error, any()}
  @spec statement(id) :: [integer]

  alias Bank.Commands.{
    AddFunds,
    SendTransfer
  }
  alias Bank.Schemas.Account
  def add_funds(id, amount) do
    Bank.Router.dispatch(%AddFunds{account_id: id, amount: amount})
  end

  def balance(id) do
    account = Bank.Repo.get(Account, id)
    account.balance
  end

  def transfer(sender_id, receiver_id, amount) do
    Bank.Router.dispatch(%SendTransfer{
      sender_id: sender_id, 
      receiver_id: receiver_id,
      amount: amount,
      transfer_id: UUID.uuid4() 
    })
  end

  def statement(_id) do
  end
end
