defmodule Bank.MixProject do
  use Mix.Project

  def project do
    [
      app: :bank,
      version: "0.1.0",
      elixir: "~> 1.6",
      env: :dev,
      start_permanent: Mix.env() == :dev,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Bank.Application, []},
      extra_applications: [
        :logger,
        :eventstore,
      ],
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:commanded, "~> 0.15"},
      {:commanded_eventstore_adapter, "~> 0.3"},
      {:ecto, "~> 2.1"},
      {:postgrex, ">= 0.0.0"},
      {:commanded_ecto_projections, "~> 0.6"},
      {:uuid, "~> 1.1"},
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.0"},
      {:absinthe, "~> 1.4.0"},
      {:absinthe_plug, "~> 1.4.0"},
    ]
  end
end
