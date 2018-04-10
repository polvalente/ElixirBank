We want to have a EventSourced application that has this API

defmodule Bank do
  @type id :: String.t
  @spec add_funds(id, integer) :: :ok | {:error, any()}
  @spec balance(id) :: integer
  @spec transfer(id, id, integer) :: :ok | {:error, any()}
  @spec statement(id) :: [integer]
end

Just to practice, lets only allow adding funds if amount is multiple of 10 (why not ¯\(ツ)/¯)
