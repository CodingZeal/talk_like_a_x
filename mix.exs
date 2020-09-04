defmodule TalkLikeAX.MixProject do
  use Mix.Project

  def project do
    [
      app: :talk_like_a_x,
      version: "0.0.1",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "Talk Like A (x)",
      source_url: "https://github.com/CodingZeal/talk_like_a_x"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:yaml_elixir, "~> 2.5"},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:deep_merge, "~> 1.0"}
    ]
  end

  defp description() do
    "Translates a string of words to a select number of lingos. Right now the only lingo available is Pirate, more to come shortly!"
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/CodingZeal/talk_like_a_x"}
    ]
  end
end
