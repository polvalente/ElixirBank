defmodule Bank.Supervisor do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_) do
    children = [
      # projections
      {Bank.AccountProjector, []},
      {Bank.Repo, []},
      {Bank.Handlers.TransferProcessManager, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
